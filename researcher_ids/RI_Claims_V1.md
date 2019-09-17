--------------------------------------------------------------------------------

# GA4GH Passports

**Version**: 0.9.5 (FROZEN RFC)

**Work Stream Name**: Data Use and Researcher Identity

**Product Name**: GA4GH Passports

**Product Description:** This document provides the GA4GH technical
specification for the
[Passport JWT Claim](#passport-jwt-claim) to be
consumed by [Passport Clearinghouses](#passport-clearinghouse) in a
standardized approach to determine whether or not data access should be
granted. Additionally, the specification provides guidance on encoding
specific [use cases](#encoding-use-cases), including [Passport
Visas](#passport-visa) for [Registered Access](#registered-access) as
described in the "[Registered access: authorizing data
access](https://www.nature.com/articles/s41431-018-0219-y) publication."
**Refer to the [Overview](#overview) for an introduction to how data
objects and services defined in this specification fit together.**

**Co-Chairs of Product Subgroup**: Stephanie Dyke (McGill) & Craig Voisin
(Google)

### Table of Contents

- [**Conventions and Terminology**](#conventions-and-terminology)
  - [Objects and Tokens](#objects-and-tokens)
    - [Passport](#passport)
    - [Passport JWT Claim](#passport-jwt-claim)
    - [Passport Visa](#passport-visa)
    - [Passport Visa Identity](#passport-visa-identity)
    - [Passport Visa Object](#passport-visa-object)
    - [Passport Visa Type](#passport-visa-type)
  - [Actors and Services](#actors-and-services)
    - [Passport Visa Assertion Source](#passport-visa-assertion-source)
    - [Passport Visa Assertion Repository](#passport-visa-assertion-repository)
    - [Passport Visa Issuer](#passport-visa-issuer)
    - [Passport Broker](#passport-broker)
    - [Passport Clearinghouse](#passport-clearinghouse)
- [**Overview**](#overview)
  - [General Requirements](#general-requirements)
  - [Support for User Interfaces](#support-for-user-interfaces)
- [**Passport JWT Claim Format**](#passport-jwt-claim-format)
  - [Passport Visa Requirements](#passport-visa-requirements)
  - [Passport Visa Format](#passport-visa-format)
    - [exp](#exp)
  - [Passport Visa Fields](#passport-visa-fields)
    - [type](#type)
    - [asserted](#asserted)
    - [value](#value)
    - [source](#source)
    - [condition](#condition)
    - [by](#by)
  - [URL Fields](#url-fields)
- [**GA4GH Standard Passport Visa Definitions**](#ga4gh-standard-passport-visa-definitions)
  - [AffiliationAndRole](#affiliationandrole)
  - [AcceptedTermsAndPolicies](#acceptedtermsandpolicies)
  - [ResearcherStatus](#researcherstatus)
  - [ControlledAccessGrants](#controlledaccessgrants)
  - [LinkedIdentities](#linkedidentities)
- [**Custom Passport Visa Types**](#custom-passport-visa-types)
- [**Encoding Use Cases**](#encoding-use-cases)
  - [Registered Access](#registered-access)
  - [Controlled Access](#controlled-access)
- [**Passport Visa Expiry**](#passport-visa-expiry)
- [**Token Revocation**](#token-revocation)
- [**Example Passport JWT Claim**](#example-passport-jwt-claim)
- [**Specification Revision History**](#specification-revision-history)

## Conventions and Terminology

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be
interpreted as described in [RFC 2119](https://tools.ietf.org/html/rfc2119).

### **Objects and Tokens**

#### Passport

-   A GA4GH-compatible access token, as per the [GA4GH AAI
    specification](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md),
    along with the [Passport JWT Claim](#passport-jwt-claim) that is
    returned from [Passport Broker](#passport-broker) service endpoints
    using such an access token.

#### Passport JWT Claim

-   The `ga4gh_passport_v1` JWT claim. It is a [GA4GH
    Claim](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#term-ga4gh-claim)
    with a claim value being a list of [Passport Visas](#passport-visa).
    
-   Passport Visas from multiple [Passport Visa
    Issuer](#passport-visa-issuer) services can be bundled together in the
    same `ga4gh_passport_v1` JWT claim.

-   For example, the following structure encodes a Passport JWT Claim:

    ```
    "ga4gh_passport_v1" : [
        <Passport Visa>,
        <Passport Visa (if more than one)>,
        ...
    ]
    ```

#### Passport Visa

-   An attestation or access assertion from a [Passport Visa Assertion
    Source](#passport-visa-assertion-source) organization that is bound to
    a [Passport Visa Identity](#passport-visa-identity) and signed by a
    [Passport Visa Issuer](#passport-visa-issuer) service whose
    signature is verifiable via its public key.

-   Encoded as an
    [Embedded Token](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#term-embedded-token)
    JWS Compact Serialization string with its decoded payload containing
    a `ga4gh_visa_v1` JWT claim.
    
-   The `ga4gh_visa_v1` JWT claim contains various properties
    ([Passport Visa Fields](#passport-visa-fields)) that describe
    the assertion and limitations thereof.
    
-   Passport Visas are included in the [Passport JWT
    Claim](#passport-jwt-claim). See the [Passport JWT Claim
    Format](#passport-jwt-claim-format) section of this specification for
    more details.

#### Passport Visa Identity

-   The {"iss", "sub"} pair of JWT standard claims ([RFC7519 section
    4.1.1](https://tools.ietf.org/html/rfc7519#section-4.1.1)) that are
    included within an [Passport Visa](#passport-visa) that represents a
    given user (such as a user account) within the "iss" system.

#### Passport Visa Object

-   A [JWT](https://tools.ietf.org/html/rfc7519#section-2) claim value for
    the `ga4gh_visa_v1` JWT claim name. The claim value is a JSON object
    that provides fields that describe a [Passport Visa](#passport-visa).

-   For field definitions, refer to the [Passport Visa
    Fields](#passport-visa-fields) section of this specification.

#### Passport Visa Type

-   The "[type](#type)" field of a [Passport Visa](#passport-visa)
    that represents the semantics of the assertion and informs all parties
    involved in the authoring or handling the assertion how to interpret
    other [Passport Visa Fields](#passport-visa-fields).
    
-   For example, a Passport Visa Type of "AffiliationAndRole" per the
    [GA4GH Standard Passport Visa Definitions](#ga4gh-standard-passport-visa-definitions)
    specifies the semantics of the Passport Visa as well as the
    expected encoding of the "[value](#value)" field for this purpose. 

-   In addition to [GA4GH Standard Passport Visa Definitions
    (types)](#ga4gh-standard-passport-visa-definitions), there MAY also
    be Passport Visas with [Custom Passport Visa
    Types](#custom-passport-visa-types).

### **Actors and Services**

#### Passport Visa Assertion Source

-   The
    [AAI Claim Source](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#term-claim-source)
    organization of an assertion.
    
-   The Passport Visa Assertion Source can store assertions in a
    [Passport Visa Assertion Repository](#passport-visa-assertion-repository).
    
-   Passport Visas encode this organization's identifier in the
    "[source](#source)" field of a [Passport Visa 
    Object](#passport-visa-object) for the assertions that it makes.

#### Passport Visa Assertion Repository

-   The [AAI Claim
    Repository](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#term-claim-repository)
    service for the assertions made by a [Passport Visa Assertion
    Source](#passport-visa-assertion-source) organization.

-   A [Passport Visa Issuer](#passport-visa-issuer) service that has
    access to the Passport Visa Assertion Repository can use these assertions
    to mint [Passport Visas](#passport-visa).

-   Passport Visas are not typically stored in the repository as signed
    tokens. Often minting of Passport Visas is done on demand from the
    raw assertion data stored in the repository.

#### Passport Visa Issuer

-   A compliant [AAI Embedded Token
    Signatory](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#term-embedded-token-signatory)
    service that signs a [Passport Visa](#passport-visa).

-   See [Conformance for Embedded Token Signatories section of the GA4GH
    AAI specification](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#conformance-for-embedded-token-signatories).

#### Passport Broker

-   A service handling Passport Visas and assembling Passports while
    conforming as a
    [Broker](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#term-broker)
    service with conformance outlined in the [Conformance for Brokers section
    of the GA4GH AAI specification](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#conformance-for-brokers).

#### Passport Clearinghouse

-   A service consuming [Passports](#passport) and conforming
    to the requirements of a [Claim
    Clearinghouse](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#term-claim-clearinghouse)
    service outlined in the [Claim Clearinghouses section of the
    GA4GH AAI specification](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#conformance-for-claim-clearinghouses-consuming-access-tokens-to-give-access-to-data).

## Overview

<a href="diagram-1"></a>
![Passport Composition](/assets/img/passport_composition.svg)

**Diagram 1: The composition of objects and tokens within a Passport.**

In Diagram 1, the objects and tokens that make up a [Passport](#passport)
come together. Note that the [Passport JWT Claim](#passport-jwt-claim) is not
encoded within the GA4GH access token. The contents of this claim are fetched
separately from the Passport Broker by sending the access token to the
appropriate Passport Broker service endpoint (see the [GA4GH AAI
Specification](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md)
for more details).

<a href="diagram-2"></a>
![Basic Passport Flow of Data](/assets/img/passport_flow_of_data_basic.svg)

**Diagram 2: basic flow of data from Passport Visa Assertion Source to Passport Clearinghouse.**

In Diagram 2, the general flow of Passport-related data from [Passport
Visa Assertion Source](#passport-visa-assertion-source) organization to [Passport
Clearinghouse](#passport-clearinghouse) service is shown at a high level. The
colors used in Diagram 2 correspond to the colors of the data from Diagram 1 to
give a sense of which services contributed the data. However, various elements
within the [Passport Visa](#passport-visa) can be collected into standard form
by either the [Passport Visa Assertion
Repository](#passport-visa-assertion-repository) service or the
[Passport Visa Issuer](#passport-visa-issuer) service depending on the
protocols and procedures employed between these components.

Implementations introduce clients, services, and procedures -- not shown in
Diagram 2 -- to provide the mechanisms to move the data between the Passport
Visa Assertion Source and the [Passport Broker](#passport-broker). This MAY be
proprietary and is beyond the scope of this specification. The flow
between these components (represented by black arrows) MAY not be direct or
conversely services shown as being separate MAY be combined into one service.
For example, some implementations MAY deploy one service that handles the
responsiblities of both the Passport Visa Issuer and the Passport Broker.

However, the data protocols, procedures, and service functionality between
the Passport Broker and the [Passport Clearinghouse](#passport-clearinghouse)
(represented by a red arrow) MUST conform with the [GA4GH Authentication and
Authorization Infrastructure (AAI) OpenID Connect Profile Specification](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md)
("GA4GH AAI Specification"). Other services, such as the Passport Visa
Issuer also has conformance obligations within these same specifications even
though the transport mechanisms as input and output may be proprietary.

The Passport Visa Assertion Repository is the repository for the Passport Visa
Assertion Source and typically does not store Passport Visas as signed tokens.
Generally, Passport Visa Issuers use the repository content to mint Passport
Visas on demand. Implementations MAY vary in this regard.

### General Requirements

1.  <a name="requirement-1"></a>
    Use of the [Passport JWT Claim](#passport-jwt-claim) MUST conform the
    the [GA4GH AAI
    Specification](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md).
    The services described in this specification MUST also conform to the
    GA4GH AAI Specification.

2.  <a name="requirement-2"></a> A Passport JWT Claim consists of a list of
    [Passport Visas](#passport-visa). These Passport Visas MUST conform to
    [Embedded Tokens](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#term-embedded-token)
    as outlined by the GA4GH AAI Specification.

3.  <a name="requirement-3"></a> Each Passport Visa may
    have a different expiry.

    -   This allows a token carrying the claims to be short lived (e.g. 10
        minutes).

    -   The same document can encode Passport Visas for any
        [Passport Clearinghouse](#passport-clearinghouse) to evaluate when
        requesting pre-authorization for a longer duration (e.g. a request can
        establish intent to access a resource over the next 60 days, even if
        this access ends up being revoked after 15 days for other reasons)
        without the creator of the document requiring knowledge of the policies
        of the Passport Clearinghouse that inspects the Passport Visas.

4.  <a name="requirement-4"></a> Passport Visas MUST have an indication of
    which organization asserted the claim (i.e. the "[source](#source)" field),
    but Passport Visas do not generally indicate individual persons involved
    in making the assertion (i.e. who assigned/signed the claim) as detailed
    identity information is not needed to make an access decision.

5.  <a name="requirement-5"></a> Additional information about identity
    that is not needed to make an access decision SHOULD not be included in the
    Passport Visas. Identity description, encoding audit details, other data
    for non-access purposes are not the intent of these Passport Visas,
    and must be handled via other means beyond the scope of this specification
    should they be needed for entities and systems with sufficient authority to
    process such information.

6.  <a name="requirement-6"></a> All Passport Visas within the
    `ga4gh_passport_v1` scope eligible for release to the requestor MUST be
    consistently provided. Reasons for limiting exchange may include user
    approval, contractual limitations, regulatory restrictions, or filtering
    claims to only the subset needed for a particular purpose, etc.

7.  <a name="requirement-7"></a> The [Passport JWT Claim](#passport-jwt-claim)
    is only included in the Passport if the `ga4gh_passport_v1` scope is
    requested from the [Passport Broker](#passport-broker) and other conditions
    are met as outlined within this specification.

    If the Passport Broker is the [Passport Visa Issuer](#passport-visa-issuer),
    it MUST set the "iss" to itself and sign such Passport Visas with its own
    private key as described in the
    [AAI Specification](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md).

8.  <a name="requirement-8"></a> Passport Visas are designed for machine
    interpretation only to make an access decision and is a non-goal to support
    rich user interface requirements nor do these claims fully encode the audit
    trail.

9.  <a name="requirement-9"></a> A Passport Visa Object MAY
    contain a "[condition](#condition)" field that restricts the Passport Visa
    to only be valid when the condition is met.

    -   For example, an identity can have several affiliations and a
        "ControlledAccessGrants" in a Passport Visa MAY be coupled to one
        of them using the Condition field.

10. <a name="requirement-10"></a> Processing a Passport within a Passport
    Clearinghouse is to abide by the following:
    
    1.  Passport Clearinghouses MUST reject all requests that provide Passports
        that fail the neccessary checks of the access token as described in
        the [GA4GH AAI
        Specification](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md).

    2.  A Passport Clearinghouse MUST ignore all Passport Visas is does not
        need to process a particular request.

    3.  Passport Clearinghouses MUST ignore Passports and Passport Visas
        unless:
    
        1.  The Passport Clearinghouse has a sufficient trust relationships
            with all of: the [Passport Broker](#passport-broker), [Passport
            Visa Assertion Source](#passport-visa-assertion-source),
            [Passport Visa Issuer](#passport-visa-issuer); or

        2.  The Passport Clearinghouse can rely on a trusted service that
            provides sufficient trust of any of the Passport Broker,
            Passport Visa Assertion Source and/or Passport Visa Issuer
            such that the Passport Clearinghouse can establish trust of all
            three such parties.

    4.  When combining Passport Visas from multiple [Passport Visa
        Identities](#passport-visa-identity) for the purposes of evaluating
        authorization, a Passport Clearinghouse MUST check the
        [LinkedIdentities](#linkedidentities) claims by trusted issuers
        and ensure that trusted sources have asserted that these Passport
        Visa Identities represent the same end user.

### Support for User Interfaces

(e.g. mapping a URI string to a human-readable description for a user
interface.)

For example, a user interface mapping of
"<https://doi.org/10.1038/s41431-018-0219-y>" to a human readable description
such as "this person is a bona fide researcher as described by the 'Registered
access: authorizing data access' publication".

Support for User Interfaces is not part of this specification. It is a non-goal
for this specification to consider the processes that would support user
interfaces, such as:

-   String definitions could be provided as a community effort (e.g. on a wiki)
    and providing some assurance that definitions have not been tampered with.

-   Any such open effort could be made easy to update and allow self-register
    new string mappings (e.g. affiliation domain name to research organization
    name)

-   May provide a rich set of internationalization/localization features for
    clients to consume.

## Passport JWT Claim Format

The [Passport JWT Claim](#passport-jwt-claim) name maps to an array of
[Passport Visas](#passport-visa) which are encoded as
[Embedded Tokens](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#term-embedded-token)
within a Passport JWT Claim.

Non-normative example of a set of Passport Visas, encoded as Embedded
Token JWS Compact Serialization strings:

```
{
  "ga4gh_passport_v1": [
    "<eyJhbGciOiJI...aaa>",
    "<eyJhbGciOiJI...bbb>"
  ]
}
```

For a more reader-friendly example, see the [Example Passport JWT
Claim](#example-passport-jwt-claim) section of the specification.

### Passport Visa Requirements

-   Passport Visas MUST conform to one of the
    [GA4GH AAI Specification Embedded Token formats](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#embedded-token-issued-by-embedded-token-signatories)
    as JWS Compact Serialization string as defined by [RFC7515 section
    7.1](https://tools.ietf.org/html/rfc7515#section-7.1).

-   Passport Visa Issuers, Passport Brokers, and Passport Clearinghouses
    MUST conform to the
    [GA4GH AAI Specification](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md)
    requirements for Embedded Tokens in their use of Passport Visas.
    
-   Clients MUST conform to the [Client/Application
    Conformance](https://github.com/cdvoisin/data-security/blob/master/AAI/AAIConnectProfile.md#clientapplication-conformance)
    of the GA4GH AAI Specification for integrating with GA4GH Passport
    services.

-   Validation, as outlined elsewhere in this specification and the
    GA4GH AAI Specification, MUST be performed before Passport Visas are
    used for identity or authorization.

### Passport Visa Format

Passport Visas are JWS Compact Serialization strings of the following
form when represented in JSON:

```
{
  "typ": "JWT",
  "alg": "RS256",
  ["jku": "<JKS-URL>",]
  "kid": "<key-identifier>"
}.
{
  "iss": "<issuer-URL>",
  "sub": "<subject-identifier>",
  ["scope": "openid ...",]
  "jti": "<token-identifier>",
  "iat": <seconds-since-epoch>,
  "exp": <seconds-since-epoch>,
  "ga4gh_visa_v1": {
    "type": "<passport-visa-type>",
    "asserted": <seconds-since-epoch>,
    "value": "<value-string>",
    "source": "<source-URL>",
    ["condition": {...},]
    ["by": "<by-identifier>"]
  }
}.<signature>
```

Where fields within the `ga4gh_visa_v1` object are as described in the
[Passport Visa Fields](#passport-visa-fields) section of this
specification except for "exp" which is a direct JWT claim and not
stored within the `ga4gh_visa_v1` object.

One of `scope` or `jku` MUST be present as described in
[Conformance for Embedded Token Signatories](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#conformance-for-embedded-token-signatories)
within the [AAI specification](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md).

#### "**exp**"

-   REQUIRED. Generally, it is seconds since unix epoch of when the
    [Passport Visa Assertion Source](#passport-visa-assertion-source)
    requires such a claim to be no longer valid. A Passport Visa
    Assertion Source MAY choose to make a claim very long lived.
    However, a [Passport Visa Issuer](#passport-visa-issuer) MAY
    choose an earlier timestamp in order to limit the claim’s duration
    within downstream Passport Clearinghouses.

-   Access is NOT necessarily removed by the `exp` timestamp. Instead,
    this timestamp may be viewed as a cut-off after which no new access
    will be granted and action to remove any existing access may
    commence anytime shortly after this cut-off period.

-   Its use by a Passport Clearinghouse is described in the
    [Passport Visa Expiry](#passport-visa-expiry) section and
    [Token Revocation](#token-revocation) section.

## Passport Visa Fields

Although standard fields within a [Passport Visa Object](#passport-visa-object)
are defined in this section, other fields MAY exist within the object
and should be ignored by any Passport Clearinghouse that is not familiar
with the use of such fields. Field names are reserved for definition by
the GA4GH DURI committee.

#### "**type**"

-   REQUIRED. A [Passport Visa Type](#passport-visa-type) that is
    either a [GA4GH Standard Passport Visa
    Definition](#ga4gh-standard-passport-visa-definition) name, or a
    [Custom Passport Visa Type](#custom-passport-visa-types) name.

#### "**asserted**"

-   REQUIRED. Seconds since unix epoch that represents when the [Passport
    Visa Assertion Source](#passport-visa-assertion-source) made the claim.
    
-   Note that the `iat` JWT claim on the Passport Visa reflects the timestamp
    of when the Passport Visa was minted whereas the `asserted` field 
    reflects when the assertion source data was last added or updated in the
    [Passport Visa Assertion Repository](#passport-visa-assertion-repository).

-   `asserted` is used by a Passport Clearinghouse is described in the
    [Passport Visa Expiry](#passport-visa-expiry) section.

-   If a Passport Visa Assertion Repository does not include enough
    information to construct an `asserted` timestamp, a [Passport Visa
    Issuer](#passport-visa-issuer) MAY use a recent timestamp (for
    example, the current timestamp) if the Passport Visa Assertion Repository
    is kept up to date such that the Passport Visa Issuer can ensure that
    the claim is valid at or near the time of minting the Passport Visa as an
    Embedded Token. However, generally it is RECOMMENDED to have the Passport
    Visa Assertion Repository provide more accurate `asserted` information.

#### "**value**"

-   REQUIRED. A string that represents the type, process and version of the
    claim. The format of the string can vary by the [Passport Visa
    Type](#passport-visa-type).

-   For example, `value` =
    "<https://doi.org/10.1038/s41431-018-0219-y>" when `type` =
    "ResearcherStatus" represents the Registered Access Bona Fide researcher
    status.

-   For the purposes of enforcing its policies for access, a Passport
    Clearinghouse evaluating the `value` field MUST:
    
    -   Validate URL strings as per the [URL Field](#url-fields)
        requirements.
    
    -   Value field strings MUST be full string case-sensitive matches
        unless the claim defines a safe and reliable format for
        partitioning into substrings and matching on the various substrings.
        For example, the standard [AffiliationAndRole
        visa](#affiliationandrole) can be reliably
        partitioned by splitting the string at the first “@” sign if such exists,
        or otherwise producing an error (denying permission).

#### "**source**"

-   REQUIRED. A [URL Field](#url-fields) that provides at a minimum the
    organization that has asserted the claim. If there is no organization
    asserting a claim, the "source" MUST be set to
    "https://no.organization".

-   For complex organizations that may require more specific information
    regarding which part of the organization made the claim, this field MAY also
    may encode some substructure to the organization that represents the origin
    of the authority of the claim. When this approach is chosen, then:

    -   The additional substructure MUST only encode the sub-organization or
        department but no other details or variables that would make it
        difficult to enumerate the full set of possible values or cause Passport
        Clearinghouses confusion about which URLs to whitelist.

    -   The additional information SHOULD be encoded into the subdomain or path
        whenever possible and SHOULD generally avoid the use of query parameters
        and anchors to represent the sub-organization.

#### "**condition**"

-   OPTIONAL. A condition on an [Passport Visa
    Object](#passport-visa-object) indicates that the Passport Visa is
    only valid if the contents of the condition are present elsewhere in the
    [Passport](#passport) and such content is both valid
    (e.g. hasn’t expired; signature of embedded token has been verified against
    the public key; etc.) and if such content is accepted by the Passport
    Clearinghouse (e.g. the issuer is trusted; the source field meets any policy
    criteria that has been established, etc.).

-   A Passport Clearinghouse MUST always check for the presence of
    the condition field and if present it MUST only accept the Passport Visa
    if it can confirm that the condition has been met.

-   In the process of finding a matching condition, a Passport Clearinghouse
    SHOULD ignore Passport Visa Objects that also have a condition, or
    otherwise MUST avoid deep nesting of condition evaluation (i.e. avoid
    condition loops, stack overflows, etc).

-   [Passport Visa Fields](#passport-visa-fields) that are not specified
    in the condition are not required to match (i.e. any value will be accepted
    within that field).

-   Format:

```
"condition": {
  "<PassportVisaType1>" : {
    "<FieldName1>": [
      "<Value1a>",
      "<Value1b>"
    ],
    "<FieldName2>": ["<Value2>"],
    ...
  },
  "<PassportVisaType2>" : { ... }
}
```

-   Condition fields are restricted to only Passport Visa Field names
    (e.g. "value", "source", etc.), except that it MUST NOT include "condition"
    (i.e. a condition cannot be placed on another condition) and MUST NOT
    contain a timestamp field such as "asserted".

    -   Note that the "source" in the condition is the expected source of the
        condition’s claim name and value, and is not the source of the claim to
        which the condition is attached.

    -   For example, "claimNameA.sourceA" asserts that "sourceA" is the
        [Passport Visa Assertion Source](#passport-visa-assertion-source) of
        "claimNameA" whereas "claimNameA.condition.claimNameB.sourceB" expects
        that "claimNameB" exists elsewhere in the Passport and is provided by
        "sourceB".

-   The Passport Clearinghouse MUST verify that for each condition claim and each
    condition field present, a single corresponding [Passport Visa
    Object](#passport-visa-object) and its corresponding
    [fields](#passport-visa-fields) match as per the matching algorithms
    described elsewhere in this specification, along with the following
    requirements:

    -   Checking the correctness of the condition MUST be performed first. For
        example, the field name but be a valid choice.

    -   A condition field matches when any one string within the specified list
        matches a corresponding claim’s field in the Passport.

    -   All condition fields that are specified MUST match the same Passport
        Visa Object in the Passport.

-   Non-normative example:

    ```
    "condition": {
      "AffiliationAndRole": {
        "value": [
          "faculty@uni-heidelberg.de",
          "student@uni-heidelberg.de"
        ],
        "by": [
          "so",
          "system"
        ]
      }
    }
    ```

    Would match a corresponding AffiliationAndRole claim within the same
    Passport Visa Object that has **any** of the following:

    -   `value` = "faculty\@uni-heidelberg.de" AND `by` = "so"

    -   `value` = "faculty\@uni-heidelberg.de" AND `by` = "system"

    -   `value` = "student\@uni-heidelberg.de" AND `by` = "so"

    -   `value` = "student\@uni-heidelberg.de" AND `by` = "system"

#### "**by**"

-   OPTIONAL. The level or type of authority within the "source" organization
    that is asserting the claim.

-   A Passport Clearinghouse MAY use this field as part of an authorization
    decision based on the policies that it enforces.

-   Fixed vocabulary values for this field are:

    -   **self**: The identity for which the claim is being made and the person
        who made the claim is the same person.

    -   **peer**: A person, who has the same ResearcherStatus as this claim, has
        made this assertion. The "source" field represents the peer’s
        organization that is asserting the claim (which isn’t necessarily the
        same as the identity’s home organization).

    -   **system**: The person’s home organization’s information system has
        asserted the claim.

    -   **so**: The person (also known as "signing official") who authorized
        this claim is within the "source" organization and at the time the claim
        was issued possessed direct authority (as part of their formal duties)
        to bind the organization to their assertion that the identity has met
        the policies indicated by this claim within the context of its "value"
        field.

    -   **dac**: A Data Access Committee or other authority that is responsible
        as a grantee decision-maker for the given "value" and "source" field
        pair.

-   If this field is not provided, then none of the above values can be assumed
    as the level or type of authority is "unknown". Any policy expecting a
    specific value as per the list above MUST fail to accept an "unknown" value.

### URL Fields

A [Passport Visa Field](#passport-visa-fields) that is defined as being of URL
format (see [RFC3986 section
1.1.3](https://tools.ietf.org/html/rfc3986?#section-1.1.3)) with the following
limitations:

1.  For the purposes of evaluating access, the URL MUST be treated as a simple
    unique persistent string identifier.

2.  The URL is a canonical identifier and as such it is important that Passport
    Clearinghouses MUST match this identifier consistently using a
    case-sensitive full string comparison.

    -   If TLS is available on the resource, then its persistent identifier URL
        SHOULD use the "https" scheme even if the resource will also resolve using
        the "http" scheme.

    -   Research institutions are RECOMMENDED to use a persistent URL pointing to
        established organizational ontology identifier -- whether managed directly
        or by a third-party service such as a [GRID](https://grid.ac/institutes)
        -- as their canonical "source" URL.

3.  The URL SHOULD also be as short as reasonably possible while avoiding
    collisions, and MUST NOT exceed 255 characters.

4.  The URL MUST NOT be fetched as part of policy evaluation when making an
    access decision. For policy evaluation, it is considered an opaque string.

5.  URLs SHOULD resolve to a human readable document for a policy maker to
    reason about.

## GA4GH Standard Passport Visa Definitions

Note: in addition to these GA4GH standard Passport Visa Types, there is also
the ability to for a Passport Visa Issuer to encode [Custom Passport Visa
Types](#custom-passport-visa-types) and still be compliant.

### AffiliationAndRole

-   The Identity’s role within the identity’s affiliated institution as
    specified by one of the following:

    -   [eduPersonScopedAffiliation](http://software.internet2.edu/eduperson/internet2-mace-dir-eduperson-201602.html#eduPersonScopedAffiliation)
        attributed value of: faculty, student, or member. \
        This term is defined by eduPerson by the affiliated organization
        (organization after the \@-sign).

        -   Example: "faculty\@cam.ac.uk"

        -   Note: based on the eduPerson specification, it is possible that
            institutions use a different definition for the meaning of "faculty"
            ranging from "someone who does research", to "someone who teaches",
            to "someone in education that works with students".

    -   A custom role that includes a namespace prefix followed by a dot (".")
        where implementers introducing a new custom claim role MUST coordinate
        with the DURI committee to align custom role use cases to maximize
        interoperability and avoid fragmentation across implementations.

        -   Example: "nih.researcher\@med.stanford.edu" where "nih" is the
            namespace and "researcher" is the custom role within that namespace.

-   If there is no affiliated institution associated with a given claim, the
    affiliation portion of AffliationAndRole MUST be set to "no.organization".

    -   Example: "public.citizen-scientist\@no.organization"
    
-   AffiliationAndRole can be safely partitioned into a {role, affiliation} pair
    by splitting the value string at the first "@" sign.

### AcceptedTermsAndPolicies

-   The set of unique identifiers in the form of URLs to indicate that the
    [Passport Visa Identity](#passport-visa-identity) or the
    "[source](#source)" organization have acknowledged the specific terms,
    policies, and conditions indicated by the URL.
    
-   The `value` field conforms to [URL Field](#url-fields) format.

-   The URLs SHOULD resolve to a public-facing, human readable web page that
    describes the terms and policies.

-   Example `value`: "<https://doi.org/10.1038/s41431-018-0219-y>"
    acknowledges the ethics terms as needed for
    [Registered Access](#registered-access) Bona Fide researcher
    status.

-   MUST include the "[by](#by)" field.

### ResearcherStatus

-   Unique identifiers in the form of URLs that indicate that the person has
    been acknowledged to be a researcher of a particular type or standard.

-   The `value` field conforms to [URL Field](#url-fields) format, and it
    indicates the minimum standard and/or type of researcher that describes
    the person represented by the given identity.

-   The URLs SHOULD resolve to a human readable web page that describes the
    process that has been followed and the qualifications this person has met.

-   Example `value`: "<https://doi.org/10.1038/s41431-018-0219-y>"
    acknowledges the registration process as needed for
    [Registered Access](#registered-access) Bona Fide researcher
    status.

### ControlledAccessGrants

-   A list of datasets or other objects for which controlled access has been
    granted to this [Passport Visa Identity](#passport-visa-identity).
    
-   The `value` field conforms to [URL Field](#url-fields) format.

-   The `source` field contains the access grantee organization.

-   MUST include "[by](#by)" field.

-   This claim MAY include a "[condition](#condition)" field.

### LinkedIdentities

-   The identity as indicated by the {"iss", "sub"} pair (aka "[Passport Visa
    Identity](#passport-visa-identity)") of the [Passport
    Visa](#passport-visa) is the same as the identities listed in the
    "[value](#value)" field.

-   The "[value](#value)" field format is a comma-delimited list of
    "<uri-encoded-sub>|<uri-encoded-iss>" entries with no added whitespace
    between entries.
  
    -   The "iss" and "sub" that are used to encode the "value" field do
        not need to conform to [URL Field](#url-fields)
        requirements since they must match the corresponding Passport Visa
        "iss" and "sub" fields that may be issued.
        
    -   By URI encoding the "iss", special characters (such as "|" and ",")
        are encoded within the URL without causing parsing conflicts.
        
    -   Example:
        "sub1|https%3A%2F%2Fexample.org%2Fa%7Cb%2Cc,sub2|https%3A%2F%2Fexample2.org".

-   The "[source](#source)" field refers to the [Passport Visa Assertion
    Source](#passport-visa-assertion-source) that is making the assertion. This is
    typically the same organization as the [Passport Visa
    Issuer](#passport-visa-issuer) "iss" that signs the Passport Visa, but the
    "source" MAY also refer to another Passport Visa Assertion Source depending
    on which organization collected the information.

-   As a non-normative example, if a policy needs 3 Passport Visas and
    there are three Passport Visas that meet the criteria on one Passport
    but they use 3 different "sub" values ("sub1", "sub2", "sub3"), then
    **any** of the following, if from a trusted issuers and sources, may
    allow these Passport Visas to be combined (shown with JSON payload only
    and without the REQUIRED URI-encoding in order to improve readability of
    the example).
    
    1. One Passport Visa that links 3 Passport Visa Identities together.
    
       ```
       {
         "iss": "https://example1.org/oidc",
         "sub": "sub1",
         "ga4gh_visa_v1": {
           "type": "LinkedIdentities",
           "value": "sub2|https://example2.org/oidc,sub3|https://example3.org/oidc",
           "source": "https://example1.org/oidc"
           ...
         }
       }
       ```
    
       or
    
    2. One Passport Visa that links a superset of Passport Visa
       Identities together.
    
       ```
       {
         "iss": "https://example0.org/oidc",
         "sub": "sub0",
         "ga4gh_visa_v1": {
           "type": "LinkedIdentities",
           "value":
             "sub1|http://example1.org/oidc,sub2|http://example2.org/oidc,sub3|http://example3.org/oidc,sub4|http://example4.org/oidc"
           "source": "https://example0.org/oidc"
           ...
         }
       }
       ```
    
       or
    
    3. Multiple Passport Visas that chain together a set or superset
       of Passport Visa Identities.
    
       ```
       {
         "iss": "https://example1.org/oidc",
         "sub": "sub1",
         "ga4gh_visa_v1": {
           "type": "LinkedIdentities",
           "value": "sub2|https://example2.org/oidc",
           "source": "https://example1.org/oidc"
           ...
         }
       },
       {
         "iss": "https://example2.org/oidc",
         "sub": "sub2",
         "ga4gh_visa_v1": {
           "type": "LinkedIdentities",
           "value": "sub3|https://example3.org/oidc",
           "source": "https://example2.org/oidc"
           ...
         }
       }
       ```

## Custom Passport Visa Types

-   In addition to the
    [GA4GH Standard Passport Visa Definitions](#ga4gh-standard-passport-visa-definitions),
    Passport Visas MAY be added using custom `type` names so long as the
    encoding of these Passport Visas will abide by the requirements described
    elsewhere in this specification.

-   Custom Passport Visa Types MUST limit personally identifiable information
    to only that which is necessary to provide authorization.

-   The custom `type` name MUST follow the format prescribed in the
    [URL Fields](#url-fields) section of the specification.

-   Implementers introducing a new custom `type` name MUST coordinate with the
    DURI committee to align custom `type` use cases to maximize interoperability
    and avoid unnecessary fragmentation across implementations.

-   Passport Clearinghouses MUST ignore all Passport Visas containing a custom
    `type` name that they do not support.

-   Non-normative example custom `type` name:
    "https://dbgap.nih.gov/passportVisaTypes/researcherStudies".

## Encoding Use Cases

Use cases include, but are not limited to the following:

### Registered Access

-   To meet the requirements of
    [Registered Access](https://doi.org/10.1038/s41431-018-0219-y) to
    data, a user needs to have **all** of the following Passport Visas:

    -   Meeting the ethics requirements is represented by:
    
        -   `type` = "AcceptedTermsAndPolicies"; and
        
        -   `value` = "<https://doi.org/10.1038/s41431-018-0219-y>"

    -   Meeting the bona fide status is represented by:
    
        -   `type` = "ResearcherStatus"; and
        
        -   `value` = "<https://doi.org/10.1038/s41431-018-0219-y>"

-   The [Passport Clearinghouse](#passport-clearinghouse) (e.g. to
    authorize a registered access beacon) needs to evaluate the
    multiple Passport Visas listed above to ensure their values match
    before granting access.
    
    -   If combining Passport Visas from multiple [Passport Visa
        Identities](#passport-visa-identity), the Passport
        Clearinghouse MUST also check the
        [LinkedIdentities](#ga4ghlinkedidentities) Passport Visas to
        determine if combining these identities came from a trusted
        [Passport Visa Issuer](#passport-visa-issuer).

### Controlled Access

-   Controlled Access to data utilizes the following [Passport Visa
    Types](#passport-visa-type):

    -   MUST utilize one or more
        [ControlledAccessGrants](#controlledaccessgrants) for
        permissions associated with specific data or datasets.
        
    -   MAY utilize the [condition](#condition) field on
        "ControlledAccessGrants" to cause such a grant to require
        a Passport Visa from a trusted Passport Visa Assertion Source to
        assert that the identity has a role within a specific organization.
        This can be achieved by using the
        [AffiliationAndRole](#affiliationandrole) Passport Visa Type on
        the `condition`.

    -   MAY utilize any other valid Passport Visa Type or `condition` fields
        that may be required to meet controlled access policies.

## Passport Visa Expiry

In addition to any other policy restrictions that a Passport Clearinghouse
may enforce, Passport Clearinghouses that provide access for a given
duration provided by the user (excluding any revocation policies) MUST
enforce one of the following algorithm options to ensure that claim expiry
is accounted for:

**Option A**: use the following algorithm to determine if the Passport Visa
is valid for the entire duration of the requested duration:

```
now()+requestedTTL < min(token.exp, token.ga4gh_visa_v1.asserted+maxAuthzTTL)
```

Where:

-   `requestedTTL` represents the duration for which access is being requested.
    Alternatively a solution may choose to have a stronger revocation policy
    instead of requiring such a duration.

-   `maxAuthzTTL` represents any additional expiry policy that the Passport
    Clearinghouse may choose to enforce. If this is not needed, it can
    effectively ignored by using a large number of years or otherwise have
    `token.ga4gh_visa_v1.asserted+maxAuthzTTL` removed and simplify the right
    hand side expression accordingly.

**Option B**: if tokens are sufficiently short lived and/or the authorization
system has an advanced revocation scheme that does not need to specify a
maxAuthzTTL as per Option A, then the check can be simplified:

```
now()+accessTokenTTL < token.exp
```

Where:

-   `accessTokenTTL` represents the duration for which an access token will be
    accepted and is bounded by the next refresh token cycle and/or any larger
    propagation delay before access is revoked, which needs to be assessed based
    on the revocation model.

## Token Revocation

As per the [GA4GH AAI Specification on Token
Revocation](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#token-revocation),
the following mechanisms are available within Passport Visa:

1.  Passport Visa Objects have an "[asserted](#asserted)" field to allow
    downstream policies to limit the life, if needed, of how long assertions
    will be accepted for use with access and refresh tokens.

2.  Passport Visas have an "[exp](#exp)" field to allow Passport
    Clearinghouses to limit the life of access and refresh tokens.

At a minimum, these Passport Visa Fields MUST be checked by all Passport
Clearinghouses and systems MUST be in place to take action to remove access by
the expiry timestamp or shortly thereafter. Propagation of these permission
changes may also require some reasonable delay.

Systems utilizing Passport Visas MAY also employ other mechanisms outlined in the
GA4GH AAI Specification. Systems employing Passport Visas MUST provide mechanisms to
limit the life of access, and specifically MUST conform to the GA4GH AAI
Specification requirements in this regard.

## Example Passport JWT Claim

This non-normative example illustrates a [Passport JWT Claim](#passport-jwt-claim)
that has Passport Visas representing Registered Access bona fide researcher
status along with other Passport Visas for access to specific Controlled Access
data. The [Passport Visa Types](#passport-visa-type) for this example are:

-   **AffiliationAndRole**: The person is a member of faculty at Stanford
    University as asserted by a Signing Official at Stanford.

-   **ControlledAccessGrants**: The person has approved access by the DAC at the
    National Cancer Institute for datasets 710 and approval for dataset 432 for
    a dataset from EGA.

    -   In this example, assume dataset 710 does not have a
        "[condition](#condition)" based on the
        AffiliationAndRole because the system that is asserting the claim has an
        out of band process to check the researcher’s affiliation and role and
        withdraw the dataset 710 claim automatically, hence it does not need the
        condition to accomplish this.

    -   In this example, assume that dataset 432 does not use an out of band
        mechanism to check affiliation and role, so it makes use of the
        "[condition](#condition)" field mechanism to
        enforce the affiliation and role. The dataset 432 claim is only valid if
        accompanied with a valid AffiliationAndRole claim for
        "faculty\@med.stanford.edu".

-   **AcceptedTermsAndPolicies**: The person has accepted the Ethics terms and
    conditions as defined by Registered Access. They took this action
    themselves.

-   **ResearcherStatus**: A Signing Official at Stanford Medicine has asserted
    that this person is a bona fide researcher as defined by the [Registered
    Access](#registered-access) model.

-   **LinkedIdentities**: A Passport Broker at example3.org has provided
    software functionality to allow a user to link their own accounts together.
    After the user has successfully logged into the two accounts and passed any
    auth challenges, the Passport Broker added the
    [LinkedIdentities](#linkedidentities) Passport Visa for those two accounts:
    (1) "10001" from example1.org, and (2) "abcd" from example2.org.
    Since the Passport Broker is signing the "LinkedIdentities"
    [Passport Visa](#passport-visa), it is acting as the [Passport Visa
    Issuer](#passport-visa-issuer).

Normally a Passport like this would include [Passport Visa
Format](#passport-visa-format) entries as JWS Compact Serialization strings,
however this example shows the result after the Embedded Tokens have been
unencoded into JSON (and reduced to include only the payload) to be more
reader-friendly.

```
"ga4gh_passport_v1": [
    {
        "iat": 1580000000,
        "exp": 1581208000,
        ...
        "ga4gh_visa_v1": {
            "type": "AffiliationAndRole",
            "asserted": 1549680000,
            "value": "faculty@med.stanford.edu",
            "source": "https://grid.ac/institutes/grid.240952.8",
            "by": "so"
        }
    },
    {
        "iat": 1580000100,
        "exp": 1581168872,
        ...
        "ga4gh_visa_v1": {
            "type": "ControlledAccessGrants",
            "asserted": 1549632872,
            "value": "https://nih.gov/dbgap/phs000710",
            "source": "https://grid.ac/institutes/grid.48336.3a",
            "by": "dac"
        }
    },
    {
        "iat": 1580000200,
        "exp": 1581168000,
        ...
        "ga4gh_visa_v1": {
            "type": "ControlledAccessGrants",
            "asserted": 1549640000,
            "value": "https://ega-archive.org/datasets/00000432",
            "source": "https://grid.ac/institutes/grid.225360.0",
            "by": "dac"
            "condition": {
                "AffiliationAndRole" : {
                    "value": ["faculty@med.stanford.edu"],
                    "source": ["https://grid.ac/institutes/grid.240952.8"],
                    "by": [
                        "so",
                        "system"
                    ]
                }
            },
        }
    },
    {
        "iss": "https://issuer.example1.org/oidc",
        "sub": "10001",
        "iat": 1580000300,
        "exp": 1581208000,
        ...
        "ga4gh_visa_v1": {
            "type": "AcceptedTermsAndPolicies",
            "asserted": 1549680000,
            "value": "https://doi.org/10.1038/s41431-018-0219-y",
            "source": "https://grid.ac/institutes/grid.240952.8",
            "by": "self"
        }
    },
    {
        "iss": "https://other.example2.org/oidc",
        "sub": "abcd",
        "iat": 1580000400,
        "exp": 1581208000,
        ...
        "ga4gh_visa_v1": {
            "type": "ResearcherStatus",
            "asserted": 1549680000,
            "value": "https://doi.org/10.1038/s41431-018-0219-y",
            "source": "https://grid.ac/institutes/grid.240952.8",
            "by": "so"
        }
    },
    {
        "iss": "https://broker.example3.org/oidc",
        "sub": "999999",
        "iat": 1580000500,
        "exp": 1581208000,
        ...
        "ga4gh_visa_v1": {
            "type": "LinkedIdentities",
            "asserted": 1549680000,
            "value": "10001|https://issuer.example1.org/oidc,abcd|https://other.example2.org/oidc",
            "source": "https://broker.example3.org/oidc",
            "by": "system"
        }
    }
]
```

## Specification Revision History

| Version | Date       | Editor                             | Notes                                                         |
|---------|------------|------------------------------------|---------------------------------------------------------------|
| 0.9.5   | 2019-08-26 | Craig Voisin                       | Embedded Tokens, LinkedIdentities, overview, new definitions  |
| 0.9.4   | 2019-08-12 | Craig Voisin                       | Introduce custom claim names, changes for "no organization"   |
| 0.9.3   | 2019-08-09 | Craig Voisin                       | Updates related to introducing Embedded Passport Tokens       |
| 0.9.2   | 2019-07-09 | Craig Voisin                       | Introduce RI Claim Object definition and use it consistently  |
| 0.9.1   | 2019-07-08 | Craig Voisin                       | Clarify use cases, rephrase multi-value, update links         |
| 0.9.0   | 2017-      | Craig Voisin, Mikael Linden et al. | Initial working version                                       |

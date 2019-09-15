--------------------------------------------------------------------------------

# GA4GH Researcher Identity & Access Claims

**Version**: 0.9.5 (FROZEN RFC)

**Work Stream Name**: Data Use and Researcher Identity

**Product Name**: GA4GH Researcher Identity & Access Claims (a.k.a. "RI Claims")

**Product Description:** This document provides the GA4GH technical
specification for the
[JWT Access Claim](#jwt-access-claim) to be
consumed by [Claim Clearinghouses](#claim-clearinghouse) in a standardized
approach to determine whether or not data access should be granted.
Additionally, the specification provides guidance on encoding specific
[use cases](#encoding-use-cases), including [Access
Assertions](#access-assertion) for [Registered Access](#registered-access)
as described in the "[Registered access: authorizing data
access](https://www.nature.com/articles/s41431-018-0219-y) publication."

**Co-Chairs of Product Subgroup**: Stephanie Dyke (McGill) & Craig Voisin
(Google)

### Table of Contents

- [**Conventions and Terminology**](#conventions-and-terminology)
  - [JWT Access Claim](#jwt-access-claim)
  - [Access Assertion](#access-assertion)
  - [Assertion Type](#assertion-type)
  - [Access Assertion Object](#access-assertion-object)
  - [Claim Source](#claim-source)
  - [Passport](#passport)
  - [Claim Clearinghouse](#claim-clearinghouse)
  - [Access Assertion Identity](#access-assertion-identity)
- [**Overview**](#overview)
  - [General Requirements](#general-requirements)
  - [Support for User Interfaces](#support-for-user-interfaces)
- [**JWT Access Claim Format**](#jwt-access-claim-format)
  - [Access Assertion Requirements](#access-assertion-requirements)
  - [Access Assertion Format](#access-assertion-format)
    - [exp](#exp)
  - [Access Assertion Fields](#access-assertion-fields)
    - [asserted](#asserted)
    - [value](#value)
    - [source](#source)
    - [condition](#condition)
    - [by](#by)
  - [URL Claim Fields](#url-claim-fields)
- [**GA4GH Standard Assertion Definitions**](#ga4gh-standard-assertion-definitions)
  - [ga4gh.AffiliationAndRole](#ga4ghaffiliationandrole)
  - [ga4gh.AcceptedTermsAndPolicies](#ga4ghacceptedtermsandpolicies)
  - [ga4gh.ResearcherStatus](#ga4ghresearcherstatus)
  - [ga4gh.ControlledAccessGrants](#ga4ghcontrolledaccessgrants)
  - [ga4gh.LinkedIdentities](#ga4ghlinkedidentities)
- [**Custom Assertion Types**](#custom-assertion-types)
- [**Encoding Use Cases**](#encoding-use-cases)
  - [Registered Access](#registered-access)
  - [Controlled Access](#controlled-access)
- [**Access Assertion Expiry**](#access-assertion-expiry)
- [**Claim and Token Revocation**](#claim-and-token-revocation)
- [**Example JWT Access Claim**](#example-jwt-access-claim)
- [**Specification Revision History**](#specification-revision-history)

## Conventions and Terminology

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be
interpreted as described in [RFC 2119](https://tools.ietf.org/html/rfc2119).

#### **JWT Access Claim**

-   A set of [Access Assertions](#access-assertion)
    provided by a common key value within the "ga4gh" JWT claim.
    
-   For example, the following structure encodes a JWT Access Claim:

    ```
    "ga4gh" : {
      "ControlledAccessGrants": [
        <Access Assertion>,
        <Access Assertion (if more than one)>,
        ...
      ]
    }
    ```

#### **Access Assertion**

-   An assertion or attestation from a [Claim Source](#claim-source) that
    is bound to a researcher identity and signed by an
    [Embedded Claim Signatory](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#term-embedded-claim-signatory)
    as per the "iss" field.

-   Encoded as an
    [Embedded Token](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#term-embedded-token)
    that contains various properties
    ([Access Assertion Fields](#access-assertion-fields)) that describe
    the assertion and limitations thereof.
    
-   Access Assertions are included in the [JWT Access
    Claim](#jwt-access-claim). See the [JWT Access Claim
    Format](#jwt-access-claim-format) section of this specification for
    more details.

#### **Assertion Type**

-   The "[type](#type)" field of an [Access Assertion](#access-assertion)
    that represents the semantics of the assertion and informs all parties
    involved in the authoring or handling the assertion how to interpret
    other Access Assertion Fields.
    
-   For example, an Assertion Type of "AffiliationAndRole" in the [GA4GH
    Standard Assertion Definitions (types)](#ga4gh-standard-assertion-definitions)
    specifies the semantics of the Access Assertion as well as the
    expected encoding of the "[value](#value)" field for this purpose. 

-   In addition to [GA4GH Standard Assertion Definitions
    (types)](#ga4gh-standard-assertion-definitions), there MAY also be
    Access Assertions with [Custom Assertion
    Types](#custom-assertion-types).

#### **Access Assertion Object**

-   A [JWT](https://tools.ietf.org/html/rfc7519#section-2) claim named
    "ga4gh_aa" in the form of a JSON object that provides fields that
    describe an Access Assertion.

-   For field definitions, refer to [Access Assertion
    Fields](#access-assertion-fields).

#### **Access Assertion Identity**

-   The {"iss", "sub"} pair of JWT standard claims ([RFC7519 section
    4.1.1](https://tools.ietf.org/html/rfc7519#section-4.1.1)) that are
    included within an [Access Assertion Object](#access-assertion-object)
    that represents a given user (such as a user account) within the "iss"
    system.

#### **Claim Source**

-   The
    [AAI Claim Source](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#term-claim-source)
    as encoded by the [source field](#source).

#### **Passport**

-   The [JWT Access Claim](#jwt-access-claim) that is returned from a
    [Broker](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#broker)
    containing a bundle of [Access Assertions](#access-assertion) along with
    other JWT claims including those on the access token and those available
    from Broker endpoints using the access token.
    See the [Conformance for Brokers section of the GA4GH AAI specification](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#conformance-for-brokers).
    
-   [Access Assertions](#access-assertion) from multiple [Embedded Token
    Signatories](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#term-embedded-token-signatory)
    can be bundled together in a [Passport](#passport).

#### **Claim Clearinghouse**

-   The service consuming claims via a [Passport](#passport) as defined by
    the
    [Claim Clearinghouses section of the GA4GH AAI specification](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#conformance-for-claim-clearinghouses-consuming-access-tokens-to-give-access-to-data).

## Overview

### General Requirements

1.  <a name="requirement-1"></a>
    The [JWT Access Claim](#jwt-access-claim) and tokens that contain
    the JWT Access Claim MUST conform the the
    [GA4GH AAI Specification](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md)
    ("AAI Specification").

2.  <a name="requirement-2"></a> A JWT Access Claim consists of a list of
    [Access Assertions](#access-assertion).

3.  <a name="requirement-3"></a> Each Access Assertion may
    have a different expiry.

    -   This allows a token carrying the claims to be short lived (e.g. 10
        minutes).

    -   The same document can encode Access Assertions for any
        [Claim Clearinghouse](#claim-clearinghouse) to evaluate when requesting
        pre-authorization for a longer duration (e.g. a request can establish
        intent to access a resource over the next 60 days, even if this access
        ends up being revoked after 15 days for other reasons) without the
        creator of the document requiring knowledge of the policies of the
        Claim Clearinghouse that inspects the Access Assertions.

4.  <a name="requirement-4"></a> Access Assertions MUST have an indication of
    which organization asserted the claim (i.e. the "[source](#source)" field),
    but Access Assertions do not generally indicate individual persons involved
    in making the assertion (i.e. who assigned/signed the claim) as detailed
    identity information is not needed to make an access decision.

5.  <a name="requirement-5"></a> Additional information about identity
    that is not needed to make an access decision SHOULD not be included in the
    Access Assertions. Identity description, encoding audit details, other data
    for non-access purposes are not the intent of these Access Assertions,
    and must be handled via other means beyond the scope of this specification
    should they be needed for entities and systems with sufficient authority to
    process such information.

6.  <a name="requirement-6"></a> All Access Assertions within the "ga4gh" scope
    eligible for release to the requestor MUST be provided. Reasons for limiting
    exchange may include user approval, contractual limitations, regulatory
    restrictions, or filtering claims to only the subset needed for a particular
    purpose, etc.

7.  <a name="requirement-7"></a> The [JWT Access Claim](#jwt-access-claim) is
    only included in the Passport if the "ga4gh" scope is requested from the
    [Broker](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#term-broker)
    and other conditions are met as outlined within this specification.

    If the Broker is the Embedded Claim Signatory, it MUST set the "iss" to
    itself and sign such Embedded Tokens with its own private key as described
    in the
    [AAI Specification](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md).

8.  <a name="requirement-8"></a> Access Assertions are designed for machine
    interpretation only to make an access decision and is a non-goal to support
    rich user interface requirements nor do these claims fully encode the audit
    trail.

9.  <a name="requirement-9"></a> An Access Assertion Object MAY
    contain a "[condition](#condition)" field that restricts the Access
    Assertion to only be valid when the condition is met.

    -   For example, an identity can have several affiliations and a
        "ControlledAccessGrants" in an Access Assertion MAY be coupled to one
        of them using the Condition field.

10. <a name="requirement-10"></a> Processing a Passport within a Claim
    Clearinghouse is to abide by the following:

    1.  A Claim Clearinghouse MUST ignore all Access Assertions is does not
        need to process a particular request and MUST ignore all Access
        Asssertions unless it explicitly has a sufficient trust relationship
        with the "[source](#source)" of the Access Assertion.

    2.  Claim Clearinghouses SHOULD ignore claims that aren’t needed for their
        purposes.
        
    3.  When combining Access Assertions from multiple [Access Assertion
        Identities](#access-assertion-identity) for the purposes of evaluating
        authorization, a Claim Clearinghouse MUST check the
        [LinkedIdentities](#ga4ghlinkedidentities) claims by trusted issuers
        to ensure that trusted sources have asserted that these Access
        Assertion Identities represent the same end user.

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

## JWT Access Claim Format

The [JWT Access Claim](#jwt-access-claim) name maps to an array of
[Access Assertions](#access-assertion) which are encoded as
[Embedded Tokens](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#term-embedded-token)
within a "ga4gh" root JWT claim object.

Non-normative example of a set of Access Assertions, encoded as Embedded
Token strings, with an Assertion Type of "ResearcherStatus":

```
{
  "ga4gh": {
    "ResearcherStatus": [
      "<eyJhbGciOiJI...aaa>",
      "<eyJhbGciOiJI...bbb>"
    ]
  }
}
```

An [example](#example-jwt-access-claim) of encoding the JWT Access Claim in a more
reader-friendly form is also available.

### Access Assertion Requirements

-   Access Assertions MUST conform to one of the
    [GA4GH AAI Specification Embedded Token formats](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#embedded-token-issued-by-embedded-token-signatories)
    as JWS Compact Serialization string as defined by [RFC7515 section
    7.1](https://tools.ietf.org/html/rfc7515#section-7.1).

-   Claim Signatories, Brokers, Claim Clearinghouses, and their Clients MUST
    conform to the
    [GA4GH AAI Specification](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md)
    requirements for Embedded Tokens in their use of Access Assertions.

-   Validation, as outlined elsewhere in this specification and the
    GA4GH AAI Specification, MUST be performed before Access Assertions are
    used for identity or authorization.

### Access Assertion Format

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
  "ga4gh_rio": {
    "asserted": <seconds-since-epoch>,
    "value": "<value-string>",
    "source": "<source-URL>",
    ["condition": {...},]
    ["by": "\<By identifier\>"]
  }
}.\<Signature\>
```

Where fields within the `ga4gh_rio` object are as described in the
[Access Assertion Fields](#access-assertion-fields) section of this
specification except for "exp" which is a direct JWT claim and not
stored within the `ga4gh_rio` object.

One of `scope` or `jku` MUST be present as described in
[Conformance for Embedded Token Signatories](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#conformance-for-embedded-token-signatories)
within the [AAI specification](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md).

#### "**exp**"

-   REQUIRED. Generally, it is seconds since unix epoch of when the
    [Claim Source](#claim-source) requires such a claim to be no longer
    valid. A Claim Source MAY choose to make a claim very long lived.
    However, an
    [Embedded Claim Signatory](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#term-embedded-claim-signatory)
    MAY choose an earlier timestamp if it wishes to limit the claim’s
    duration of use within downstream Claim Clearinghouses.

-   Access is NOT necessarily removed by the `exp` timestamp. Instead,
    this timestamp may be viewed as a cut-off after which no new access
    will be granted and action to remove any existing access may
    commence anytime shortly after this cut-off period.

-   Its use by a Claim Clearinghouse is described in the
    [Access Assertion Expiry](#access-assertion-expiry) section and
    [Token Revocation](#claim-and-token-revocation) section.

## Access Assertion Fields

Fields within an [Access Assertion Object](#access-assertion-object)
are:

#### "**type**"

-   REQUIRED. An [Assertion Type](#assertion-type) that is either a
    [GA4GH Standard Assertion Definition](#ga4gh-standard-assertion-definition)
    name, or a [Custom Assertion Type](#custom-assertion-types) name.

#### "**asserted**"

-   REQUIRED. Seconds since unix epoch that represents when the [Claim
    Source](#claim-source) made the claim.

-   Its use by a Claim Clearinghouse is described in the
    [Access Assertion Expiry](#access-assertion-expiry) section.

-   If a [Claim
    Repository](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#term-claim-respository)
    does not include enough information to construct an `iat` timestamp, an
    Embedded Token Signatory MAY use a recent timestamp (for example, the
    `iat` timestamp) if the Claim Repository is kept up to date such that
    the Embedded Token Signatory can ensure that the claim is valid at or
    near the time of minting the Embedded Token. However, generally it is
    RECOMMENDED to have the Claim Repository provide more accurate `iat`
    information.

#### "**value**"

-   REQUIRED. A string that represents the type, process and version of the claim. The
    format of the string can vary by the [Assertion Type](#assertion-type).

-   For example, ga4gh.ResearcherStatus.value =
    "<https://doi.org/10.1038/s41431-018-0219-y>” represents the Registered
    Access Bona Fide researcher status.

-   For the purposes of enforcing its policies for access, a Claim Clearinghouse
    evaluating the "value" field MUST:
    
    -   Validate URL strings as per the [URL Claim Field](#url-claim-field)
        requirements.
    
    -   Value field strings MUST be full string case-sensitive matches unless the
        claim defines a safe and reliable format for partitioning into substrings
        and matching on the various substrings. For example, the standard
        [AffiliationAndRole claim](#ga4ghaffiliationandrole) can be reliably
        partitioned by splitting the string at the first “@” sign if such exists,
        or otherwise producing an error (denying permission).

#### "**source**"

-   REQUIRED. A [URL Claim Field](#url-claim-fields) that provides at a minimum the
    organization that has asserted the claim. If there is no organization
    asserting a claim, the "source" MUST be set to
    "https://no.organization".

-   For complex organizations that may require more specific information
    regarding which part of the organization made the claim, this field MAY also
    may encode some substructure to the organization that represents the origin
    of the authority of the claim. When this approach is chosen, then:

    -   The additional substructure MUST only encode the sub-organization or
        department but no other details or variables that would make it
        difficult to enumerate the full set of possible values or cause Claim
        Clearinghouses confusion about which URLs to whitelist.

    -   The additional information SHOULD be encoded into the subdomain or path
        whenever possible and SHOULD generally avoid the use of query parameters
        and anchors to represent the sub-organization.

#### "**condition**"

-   OPTIONAL. A condition on an [Access Assertion
    Object](#access-assertion-object) indicates that the Access Assertion is
    only valid if the contents of the condition are present elsewhere in the
    [Passport](#passport) and such content is both valid
    (e.g. hasn’t expired; signature of embedded token has been verified against
    the public key; etc.) and such content is accepted by the Claim
    Clearinghouse (e.g. the issuer is trusted; the source field meets any policy
    criteria that has been established, etc.).

-   A Claim Clearinghouse MUST always check for the presence of
    the condition field and if present it MUST only accept the Access Assertion
    Object if it can confirm that the condition has been met.

-   In the process of finding a matching condition, a Claim Clearinghouse
    SHOULD ignore Access Assertion Objects that also have a condition, or
    otherwise MUST avoid deep nesting of condition evaluation (i.e. avoid
    condition loops, stack overflows, etc).

-   [Access Assertion Fields](#access-assertion-fields) that are not specified
    in the condition are not required to match (i.e. any value will be accepted
    within that field).

-   Format:

```
"condition": {
  "<ClaimName1>" : {
    "<FieldName1>": [
      "<Value1a>",
      "<Value1b>"
    ],
    "<FieldName2>": ["<Value2>"],
    ...
  },
  "<ClaimName2>" : { ... }
}
```

-   Condition fields are restricted to only Access Assertion Field names
    (e.g. "value", "source", etc.), except that it MUST NOT include "condition"
    (i.e. a condition cannot be placed on another condition) and MUST NOT
    contain a timestamp field such as "asserted".

    -   Note that the "source" in the condition is the expected source of the
        condition’s claim name and value, and is not the source of the claim to
        which the condition is attached.

    -   For example, "claimNameA.sourceA" asserts that "sourceA" is the
        [Claim Source](#claim-source) of "claimNameA" whereas
        "claimNameA.condition.claimNameB.sourceB" expects that "claimNameB"
        exists elsewhere in the Passport and is provided by "sourceB".

-   The Claim Clearinghouse MUST verify that for each condition claim and each
    condition field present, a single corresponding [Access Assertion
    Object](#access-assertion-object) and its corresponding
    [fields](#claim-object-fields) match as per the matching algorithms
    described elsewhere in this specification, along with the following
    requirements:

    -   Checking the correctness of the condition MUST be performed first. For
        example, the field name but be a valid choice.

    -   A condition field matches when any one string within the specified list
        matches a corresponding claim’s field in the Passport.

    -   All condition fields that are specified MUST match the same Access
        Assertion Object in the Passport.

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
    Access Assertion Object that has any of the following:

    -   value = "faculty\@uni-heidelberg.de" AND by = "so"

    -   value = "faculty\@uni-heidelberg.de" AND by = "system"

    -   value = "student\@uni-heidelberg.de" AND by = "so"

    -   value = "student\@uni-heidelberg.de" AND by = "system"

#### "**by**"

-   OPTIONAL. The level or type of authority within the "source" organization
    that is asserting the claim.

-   A Claim Clearinghouse MAY use this field as part of an authorization
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

### URL Claim Fields

An [Access Assertion Field](#access-assertion-fields) that is defined as being
of URL format with the following limitations:

1.  For the purposes of evaluating access, the URL MUST be treated as a simple
    unique persistent string identifier.

2.  The URL is a canonical identifier and as such it is important that Claim
    Clearinghouses MUST match this identifier consistently using a
    case-sensitive full string comparison.

    -   Note that these URLs SHOULD use "https" in a canonical identifier even
        if the human readable document will resolve using either scheme.

    -   Research institutions are encouraged to use a persistent URL pointing to
        established organizational ontology URL such as a
        [GRID URL](https://grid.ac/institutes) as their canonical "source" URL.

3.  The URL SHOULD also be as short as reasonably possible while avoiding
    collisions, and MUST NOT exceed 255 characters.

4.  The URL MUST NOT be fetched by the algorithm making an access decision.

5.  URLs SHOULD resolve to a human readable document for a policy maker to
    reason about.

## GA4GH Standard Assertion Definitions

This is the list of standard Assertion Types. Note that there are also
[Custom Assertion Types](#custom-assertion-types).

### ga4gh.AffiliationAndRole

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

### ga4gh.AcceptedTermsAndPolicies

-   The set of unique identifiers in the form of URLs that indicate that a
    researcher or their organization has acknowledged the specific terms and
    policies indicated by the URL.

-   The URLs SHOULD resolve to a public-facing, human readable web page that
    describes the terms and policies.

-   Example value: "<https://doi.org/10.1038/s41431-018-0219-y>" acknowledges
    the ethics terms as needed for
    [Registered Access](#registered-access) Bona Fide researcher
    status.

-   MUST include "[by](#by)" field.

### ga4gh.ResearcherStatus

-   Unique identifiers in the form of URLs that indicate that the person has
    been acknowledged to be a researcher of a particular type or standard.

-   The "value" field of the claim indicates the minimum standard and/or type of
    researcher that describes the person represented by the given identity.

-   The URLs SHOULD resolve to a human readable web page that describes the
    process that has been followed and the qualifications this person has met.

-   Example value: "<https://doi.org/10.1038/s41431-018-0219-y>" acknowledges
    the registration process as needed for
    [Registered Access](#registered-access) Bona Fide researcher
    status.

### ga4gh.ControlledAccessGrants

-   A list of datasets or other objects for which controlled access has been
    granted to this researcher.

-   The "source" field contains the access grantee organization.

-   MUST include "[by](#by)" field.

-   This claim MAY include a
    "[condition](#condition)" field.

### ga4gh.LinkedIdentities

-   The identity as indicated by the {"iss", "sub"} pair (aka "[Access
    Assertion Identity](#access-assertion-identity)") of the [Access
    Assertion](#access-assertion) is the same as the identities listed in
    the "[value](#value)" field.

-   The "[value](#value)" field format is a comma-delimited list of
    "<uri-encoded-sub>|<uri-encoded-iss>" entries with no added whitespace
    between entries.
  
    -   The "iss" and "sub" that are used to encode the "value" field do
        not need to conform to [URL Claim Field](#url-claim-fields)
        requirements since they must match the corresponding Access Assertion
        "iss" and "sub" fields that may be issued.
        
    -   By URI encoding the "iss", special characters (such as "|" and ",")
        are encoded within the URL without causing parsing conflicts.
        
    -   Example:
        "sub1|https%3A%2F%2Fexample.org%2Fa%7Cb%2Cc,sub2|https%3A%2F%2Fexample2.org".

-   The "[source](#source)" field refers to the [Claim Source](#claim-source)
    that is making the assertion. This is typically the same organization as
    the [Embedded Claim
    Signatory](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#term-embedded-claim-signatory)
    "iss" that signs the Access Assertion, but the "source" MAY also refer
    to another Claim Source depending on how the information was collected.

-   As a non-normative example, if a policy needs 3 Access Assertions and
    there are three Access Assertions that meet the criteria on one Passport
    but they use 3 different "sub" values ("sub1", "sub2", "sub3"), then
    **any** of the following, if from a trusted issuers and sources, may
    allow these Access Assertions to be combined (here shown without the
    REQUIRED URI-encoding in order to improve readability of the example).
    
    1. One Access Assertion that links 3 Access Assertion Identities
       together.
    
       ```
       {
         "iss": "https://example1.org/oidc",
         "sub": "sub1",
         "ga4gh_rio": {
           "value": "sub2|https://example2.org/oidc,sub3|https://example3.org/oidc",
           "source": "https://example1.org/oidc"
           ...
         }
       }
       ```
    
       or
    
    2. One Access Assertion that links a superset of Access Assertion
       Identities together.
    
       ```
       {
         "iss": "https://example0.org/oidc",
         "sub": "sub0",
         "ga4gh_rio": {
           "value":
             "sub1|http://example1.org/oidc,sub2|http://example2.org/oidc,sub3|http://example3.org/oidc,sub4|http://example4.org/oidc"
           "source": "https://example0.org/oidc"
           ...
         }
       }
       ```
    
       or
    
    3. Multiple Access Assertions that chain together a set or superset
       of Access Assertion Identities.
    
       ```
       {
         "iss": "https://example1.org/oidc",
         "sub": "sub1",
         "ga4gh_rio": {
           "value": "sub2|https://example2.org/oidc",
           "source": "https://example1.org/oidc"
           ...
         }
       },
       {
         "iss": "https://example2.org/oidc",
         "sub": "sub2",
         "ga4gh_rio": {
           "value": "sub3|https://example3.org/oidc",
           "source": "https://example2.org/oidc"
           ...
         }
       }
       ```

## Custom Assertion Types

-   In addition to the
    [GA4GH Standard Assertion Definitions](#ga4gh-standard-assertion-definitions),
    Access Assertions MAY be added using custom `type` names so long as the
    encoding of these Access Assertions will abide by the requirements described
    elsewhere in this specification.

-   Custom access assertion types MUST limit personally identifiable information
    to only that which is neccessary to provide authorization.

-   The custom `type` name MUST follow the format prescribed in the
    [URL Claim Fields](#url-claim-fields) section of the specification.

-   Implementers introducing a new custom `type` name MUST coordinate with the
    DURI committee to align custom `type` use cases to maximize interoperability
    and avoid unnecessary fragmentation across implementations.

-   Claim Clearinghouses MUST ignore any custom `type` name that they do not
    support.

-   Non-normative example custom `type` name:
    "https://dbgap.nih.gov/riAssertionTypes/researcherStudies".

## Encoding Use Cases

Use cases include, but are not limited to the following:

### Registered Access

-   To meet the requirements of
    [Registered Access](https://doi.org/10.1038/s41431-018-0219-y) to
    data, a user needs to have **all** of the following Access Assertions:

    -   Meeting the ethics requirements is represented by
        ga4gh.AcceptedTermsAndPolicies.value= \
        "<https://doi.org/10.1038/s41431-018-0219-y>"

    -   Meeting the bona fide status is represented by
        ga4gh.ResearcherStatus.value= \
        "<https://doi.org/10.1038/s41431-018-0219-y>"

-   The [Claim Clearinghouse](#claim-clearinghouse) (e.g. to authorize a
    registered access beacon) needs to evaluate the multiple Access
    Assertions listed above to ensure their values match before granting
    access.
    
    -   If combining Access Assertions from multiple Access Assertion
        Identities, the Claim Clearinghouse MUST also check the
        `LinkedIdentities` Access Assertions to determine if combining
        these identities came from a trusted Embedded Token Signatory.

### Controlled Access

-   Controlled Access to data MAY make use of any of the following [Assertion
    Types](#assertion-type):

    -   [ga4gh.ControlledAccessGrants](#ga4ghcontrolledaccessgrants) for
        permissions associated with specific data or datasets.
        
    -   [ga4gh.AffiliationAndRole](#ga4ghaffiliationandrole) to associate a user
        with a role within a specific organization. Additionally the
        ga4gh.ControlledAccessGrants MAY make use of the role and affiliation
        through a [condition](#condition) field.
        
    -   Any other Assertion Type that may be required to meet controlled access
        policies.

## Access Assertion Expiry

In addition to any other policy restrictions that a Claim Clearinghouse may
enforce, Claim Clearinghouses that provide access for a given duration provided
by the user (excluding any revocation policies) MUST enforce one of the
following algorithm options to ensure that claim expiry is accounted for:

**Option A**: use the following algorithm to determine if the Access Assertion
is valid for the entire duration of the requested duration:

```
now()+requestedTTL < min("token.exp", "token.ga4gh_rio.asserted"+maxAuthzTTL)
```

Where:

-   `requestedTTL` represents the duration for which access is being requested.
    Alternatively a solution may choose to have a stronger revocation policy
    instead of requiring such a duration.

-   `maxAuthzTTL` represents any additional expiry policy that the Claim
    Clearinghouse may choose to enforce. If this is not needed, it can
    effectively ignored by using a large number of years or otherwise have
    "token.ga4gh_rio.asserted"+maxAuthzTTL removed and simplify the right hand
    side expression accordingly.

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

## Claim and Token Revocation

As per the
[GA4GH AAI Specification on Token Revocation](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#token-revocation),
the following mechanisms are available within Access Assertions:

1.  Access Assertion Objects have an "[asserted](#asserted)" field to allow
    downstream policies to limit the life, if needed, of how long assertions
    will be accepted for use with access and refresh tokens.

2.  Access Assertions have an "[exp](#exp)" field to allow Claim
    Clearinghouses to limit the life of access and refresh tokens.

At a minimum, these Access Assertion Fields MUST be checked by all Claim
Clearinghouses and systems MUST be in place to take action to remove access by
the expiry timestamp or shortly thereafter. Propagation of these permission
changes may also require some reasonable delay.

Systems utilizing Access Assertions MAY also employ other mechanisms outlined in the
GA4GH AAI Specification. Systems employing Access Assertions MUST provide mechanisms to
limit the life of access, and specifically MUST conform to the GA4GH AAI
Specification requirements in this regard.

## Example JWT Access Claim

This non-normative example illustrates a [JWT Access Claim](#jwt-access-claim)
that has Access Assertions representing Registered Access bona fide researcher
status along with Access Assertions for access to specific Controlled Access
data. The Assertion Types for this example are:

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
    that this person is a bona fide researcher as defined by Registered Access.

-   **LinkedIdentities**: An Broker at example3.org has provided software
    functionality to allow a user to link their own accounts together. After the
    user has successfully logged into the two accounts and passed any auth
    challenges, the broker added the **LinkedIdentities** claim for those two
    accounts: (1) "10001" from example1.org, and (2) "abcd" from example2.org.
    Since the Broker is signing the `LinkedIdentities`
    [Access Assertion](#access-assertion), it is acting as the
    [Embedded Claim Signatory](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#term-embedded-claim-signatory).

Normally a Passport like this would include [Access Assertion
Format](#access-assertion-format) entries as JWS Compact Serialization strings,
however this example shows the result after the Embedded Tokens have been
unencoded into JSON to be more reader-friendly.

```
"ga4gh": {
  "AffiliationAndRole": [
    {
      "iat": 1580000000,
      "exp": 1581208000,
      ...
      "ga4gh_rio": {
        "asserted": 1549680000,
        "value": "faculty@med.stanford.edu",
        "source": "https://grid.ac/institutes/grid.240952.8",
        "by": "so"
      }
    }
  ],
  "ControlledAccessGrants": [
    {
      "iat": 1580000100,
      "exp": 1581168872,
      ...
      "ga4gh_rio": {
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
      "ga4gh_rio": {
        "asserted": 1549640000,
        "value": "https://ega-archive.org/datasets/00000432",
        "source": "https://grid.ac/institutes/grid.225360.0",
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
        "by": "dac"
      }
    }
  ],
  "AcceptedTermsAndPolicies": [
    {
      "iss": "https://issuer.example1.org/oidc",
      "sub": "10001",
      "iat": 1580000300,
      "exp": 1581208000,
      ...
      "ga4gh_rio": {
        "asserted": 1549680000,
        "value": "https://doi.org/10.1038/s41431-018-0219-y",
        "source": "https://grid.ac/institutes/grid.240952.8",
        "by": "self"
      }
    }
  ],
  "ResearcherStatus": [
    {
      "iss": "https://other.example2.org/oidc",
      "sub": "abcd",
      "iat": 1580000400,
      "exp": 1581208000,
      ...
      "ga4gh_rio": {
        "asserted": 1549680000,
        "value": "https://doi.org/10.1038/s41431-018-0219-y",
        "source": "https://grid.ac/institutes/grid.240952.8",
        "by": "so"
      }
    }
  ],
  "LinkedIdentities": [
    {
      "iss": "https://broker.example3.org/oidc",
      "sub": "999999",
      "iat": 1580000500,
      "exp": 1581208000,
      ...
      "ga4gh_rio": {
        "asserted": 1549680000,
        "value": "10001|https://issuer.example1.org/oidc,abcd|https://other.example2.org/oidc",
        "source": "https://broker.example3.org/oidc",
        "by": "system"
      }
    }
  ]
}
```

## Specification Revision History

| Version | Date       | Editor                             | Notes                                                         |
|---------|------------|------------------------------------|---------------------------------------------------------------|
| 0.9.5   | 2019-08-26 | Craig Voisin                       | RI Claim Embedded Tokens and LinkedIdentities claim           |
| 0.9.4   | 2019-08-12 | Craig Voisin                       | Introduce custom claim names, changes for "no organization"   |
| 0.9.3   | 2019-08-09 | Craig Voisin                       | Updates related to introducing Embedded Passport Tokens       |
| 0.9.2   | 2019-07-09 | Craig Voisin                       | Introduce RI Claim Object definition and use it consistently  |
| 0.9.1   | 2019-07-08 | Craig Voisin                       | Clarify use cases, rephrase multi-value, update links         |
| 0.9.0   | 2017-      | Craig Voisin, Mikael Linden et al. | Initial working version                                       |

--------------------------------------------------------------------------------

# GA4GH Researcher Identity & Access Claims

**Version**: 0.9.5 (FROZEN RFC)

**Work Stream Name**: Data Use and Researcher Identity

**Product Name**: Researcher Identity & Access Claims (a.k.a. “RI Claims”)

**Product Description:** This document provides the GA4GH technical
specification for
[GA4GH Researcher Identity Claims](#researcher-identity-claim-ri-claim) to be
consumed by [Claim Clearinghouses](#claim-clearinghouse) in a standardized
approach to determine whether or not data access should be granted.
Additionally, the specification provides guidance on encoding specific
[use cases](#encoding-use-cases), including [Registered Access claims](#registered-access) as described in the “[Registered access: authorizing data access](https://www.nature.com/articles/s41431-018-0219-y) publication.”

**Co-Chairs of Product Subgroup**: Stephanie Dyke (McGill) & Craig Voisin
(Google)

### Table of Contents

- [**Conventions and Terminology**](#conventions-and-terminology)
  - [Researcher Identity Claim ("RI Claim")](#researcher-identity-claim-ri-claim)
  - [Researcher Identity Claim Embedded Token ("RI Claim Embedded Token")](#researcher-identity-claim-embedded-token-ri-claim-embedded-token)
  - [Researcher Identity Claim Object ("RI Claim Object")](#researcher-identity-claim-object-ri-claim-object)
  - [Claim Source](#claim-source)
  - [Passport](#passport)
  - [Passport Access Token](#passport-access-token)
  - [Claim Clearinghouse](#claim-clearinghouse)
  - [RI Claim Object Identity](#ri-claim-object-identity)
- [**Researcher Identity Claim Overview**](#researcher-identity-claim-overview)
  - [RI Claims Requirements](#ri-claims-requirements)
  - [Support for User Interfaces](#support-for-user-interfaces)
- [**RI Claim Embedded Token**](#ri-claim-embedded-token)
  - [RI Claim Embedded Token Requirements](#ri-claim-embedded-token-requirements)
  - [RI Claim Embedded Token Format](#ri-claim-embedded-token-format)
    - [iat](#iat)
    - [exp](#exp)
  - [RI Claim Object Fields](#ri-claim-object-fields)
    - [value](#value)
    - [source](#source)
    - [condition](#condition)
    - [by](#by)
  - [URL Claim Fields](#url-claim-fields)
  - [Claim Expiry](#claim-expiry)
- [**GA4GH Researcher Identity Claim Definitions**](#ga4gh-researcher-identity-claim-definitions)
  - [ga4gh.AffiliationAndRole](#ga4ghaffiliationandrole)
  - [ga4gh.AcceptedTermsAndPolicies](#ga4ghacceptedtermsandpolicies)
  - [ga4gh.ResearcherStatus](#ga4ghresearcherstatus)
  - [ga4gh.ControlledAccessGrants](#ga4ghcontrolledaccessgrants)
  - [ga4gh.LinkedIdentities](#ga4ghlinkedidentities)
- [**Custom Researcher Identity Claim Names**](#custom-researcher-identity-claim-names)
- [**Encoding Use Cases**](#encoding-use-cases)
  - [Registered Access](#registered-access)
  - [Controlled Access](#controlled-access)
- [**Claim and Token Revocation**](#claim-and-token-revocation)
- [**Example RI Claims**](#example-ri-claims)
- [**Specification Revision History**](#specification-revision-history)

## Conventions and Terminology

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be
interpreted as described in [RFC 2119](https://tools.ietf.org/html/rfc2119).

#### **Researcher Identity Claim ("RI Claim")**

-   A set of [RI Claim Embedded Tokens](#researcher-identity-claim-embedded-token-ri-claim-embedded-token)
    provided by a common key value within the "ga4gh" OIDC claim. For example, the
    following structure encodes a "ga4gh.ControlledAccessGrants" RI Claim:

    ```
    "ga4gh" : {
      "ControlledAccessGrants": [
        <RI Claim Embedded Token (see definition below)>,
        <RI Claim Embedded Token (if more than one)>,
        ...
      ]
    }
    ```

    RI Claims can be bundled together in a [Passport](#passport).

#### **Researcher Identity Claim Embedded Token ("RI Claim Embedded Token")**

-   An Assertion from a [Claim Source](#claim-source) that is bound to a
    researcher identity and signed by an
    [Embedded Claim Signatory](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#term-embedded-claim-signatory)
    as per the "iss" field.

-   Encoded as an
    [Embedded Token](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#term-embedded-token)
    that contains various properties
    ([RI Claim Object Fields](#ri-claim-object-fields)) that describe the assertion and
    limitations thereof.
    
-   RI Claim Embedded Tokens are encoded as strings and included as a list of
    strings returned within a [RI Claim](#researcher-identity-claim-ri-claim). See
    the [RI Claim Embedded Token](#ri-claim-embedded-token) section of this
    specification for more details.

#### **Researcher Identity Claim Object ("RI Claim Object")**

An OIDC claim "ga4gh_rio" that contains fields that provide GA4GH
standard information about a claim that is not captured in the standard
set of claims published by underlying OIDC specification.

For field definitions, refer to [RI Claim Object Fields](#ri-claim-object-fields).

#### **RI Claim Object Identity**

-   The {"iss", "sub"} pair of OIDC standard claims that are included
    within an [RI Claim Object](#researcher-identity-claim-object) that
    represents a given user (such as a user account) within the "iss"
    system.

#### **Claim Source**

-   The
    [AAI Claim Source](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#term-claim-source)
    as encoded by the [source field](#source).

#### **Passport**

-   A logical collection of RI Claims that includes claims on the
    [Passport Access Token](#passport-access-token) as well as any
    indirect RI Claims that such a JWT token makes available to the
    caller of the corresponding /userinfo endpoint.

#### **Passport Access Token**

-   A
    [specialized JWT access token](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#ga4gh-jwt-format)
    that is signed by an
    [Identity Broker](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#term-identity-broker)
    as per the
    [GA4GH AAI specification](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md)
    for the purpose of encoding identity and evaluating authorization.
    
-   A Passport Access Token does not contain any
    [RI Claims](#researcher-identity-claim-ri-claim) within the JWT
    access token itself, but it does offer the cabability to release
    RI Claims via the /userinfo endpoint as described elsewhere in
    this specification.

#### **Claim Clearinghouse**

-   The service consuming claims via a [Passport](#passport) as defined by
    the
    [Claim Clearinghouses section of the GA4GH AAI specification](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#conformance-for-claim-clearinghouses-consuming-access-tokens-to-give-access-to-data).

## Researcher Identity Claim Overview

### RI Claims Requirements

1.  <a name="requirement-1"></a>
    [RI Claims](#researcher-identity-claim-ri-claim) and tokens that contain RI
    Claims MUST conform the the
    [GA4GH AAI Specification](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md)
    ("AAI Specification").

2.  <a name="requirement-2"></a> Each RI Claim consists of a list of
    [RI Claim Embedded Tokens](#ri-claim-embedded-token).

3.  <a name="requirement-3"></a> Each RI Claim Embedded Token may
    have a different expiry.

    -   This allows a token carrying the claims to be short lived (e.g. 10
        minutes).

    -   The same document can encode claims for any
        [Claim Clearinghouse](#claim-clearinghouse) to evaluate when requesting
        pre-authorization for a longer duration (e.g. a request can establish
        intent to access a resource over the next 60 days, even if this access
        ends up being revoked after 15 days for other reasons).

4.  <a name="requirement-4"></a> RI Claim Embedded Tokens MUST
    have an indication of which organization asserted the claim (i.e. the
    "[source](#source)" field), but RI Claim Embedded Tokens do not generally
    indicate individual persons involved in making the assertion (i.e. who
    assigned/signed the claim) as detailed identity information is not
    needed to make an access decision.

5.  <a name="requirement-5"></a> Additional information about claims that is not
    needed to make an access decision SHOULD not be included in the claim.
    Auditing and other purposes are not the intent of these standard RI Claims,
    and must be handled via another means beyond the scope of this specification
    with sufficient authority to expose such information.

6.  <a name="requirement-6"></a> All RI Claims within the "ga4gh" scope eligible
    for release to the requestor MUST be provided. Reasons for limiting exchange
    may include user approval, contractual limitations, regulatory restrictions,
    or filtering claims to only the subset needed for a particular purpose, etc.

7.  <a name="requirement-7"></a> When an
    [Identity Broker](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#term-identity-broker)
    receives a request with the "ga4gh" scope, it MUST provide RI claims under
    the "ga4gh" OIDC claim as follows:

    1.  The Identity Broker collects the claims, potentially from multiple
        sources including any upstream Identity Brokers.

    2.  The Identity Broker populates the "ga4gh_userinfo_claims" OIDC claim
        on the token as well as other claims as per the
        [GA4GH Access Token format](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#access-token-issued-by-broker),
        and MUST NOT include the "ga4gh" claims within the Passport Access
        Token. The RI Claims are only available at the /userinfo endpoint
        based on the "scope" claim as outlined elsewhere within this
        specification.

    3.  The Identity Broker introduces new RI Claim Embedded Tokens from a
        [Claim Signatory](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#term-embedded-claim-signatory)
        by encoding RI Claim Objects within the "ga4gh" OIDC claim (available
        via /userinfo). If the Broker is the Claim Signatory, it MUST set
        the "iss" to itself and sign such Embedded Tokens with its own
        private key as described in the
        [AAI Specification](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md).

    4.  The Identity Broker propagates RI Claims that it received
        from upstream Brokers by copying each RI Claim Object Embedded
        Token string into the coorsponding RI Claim within the outer "ga4gh"
        OIDC claim. These strings are provided unmodified, however they
        MAY be filtered as described elsewhere in this specification.

    5.  The Identity Broker signs the JWT, making it a Passport Access
        Token.

    6.  The Passport for the /userinfo request MUST contain "ga4gh" as a
        space-separated sub-string within the "scope" claim in order to
        include the "ga4gh" OIDC claim as part of the response.

8.  <a name="requirement-8"></a> RI Claims are designed for machine
    interpretation only to make an access decision and is a non-goal to support
    rich user interface requirements nor do these claims fully encode the audit
    trail.

9.  <a name="requirement-9"></a> An RI Claim Embedded Token MAY
    contain a "[condition](#condition)" field that restricts the RI Claim
    Embedded Token to only be valid when the condition is met.

    -   For example, an identity can have several affiliations and a
        ControlledAccessGrants in a RI Claim Embedded Token MAY be
        coupled to one of them using the Condition field.

10. <a name="requirement-10"></a> Processing a Passport within a Claim
    Clearinghouse is to abide by the following:

    1.  A Claim Clearinghouse MUST ignore all RI Claim Embedded Tokens
        is does not need to process a particular request and MUST ignore all
        RI Claim Embedded Tokens unless it explicitly has a sufficient trust
        relationship with the "[source](#source)" of the RI Claim Embedded Token.

    2.  Claim Clearinghouses SHOULD ignore claims that aren’t needed for their
        purposes.
        
    3.  When combining RI Claim Objects from multiple RI Claim Accounts for
        the purposes of evaluating authorization, a Claim Clearinghouse MUST
        check the [LinkedIdentities](#ga4ghlinkedidentities) claims by trusted
        issuers to ensure that trusted sources have asserted that these
        [RI Claim Object Identities](#ri-claim-object-identity) represent the
        same end user.

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

## RI Claim Embedded Token

Each [RI claim](#researcher-identity-claim-ri-claim) name maps to an array of
([RI Claim Embedded Tokens](#researcher-identity-claim-embedded-token-ri-claim-embedded-token))
which are encoded as
[Embedded Tokens](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#term-embedded-token)
within a "ga4gh" root OIDC claim object.

Non-normative example of a set of RI Claim Embedded Tokens, encoded as Embedded
Token strings, with a RI Claim named "ResearcherStatus":

```
{
  "ga4gh": {
    "ResearcherStatus": [
      "eyJhbGciOiJI...aaa",
      "eyJhbGciOiJI...bbb"
    ]
  }
}
```

An [example](#example-ri-claims) of encoding multiple RI Claims in a more
reader-friendly form is also available.

### RI Claim Embedded Token Requirements

-   RI Claim Embedded Tokens MUST conform to the
    [GA4GH AAI Specification Embedded Token format](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#embedded-token-issued-by-broker)
    as a base64 string.

-   Claim Signatories, Identity Brokers, Claim Clearinghouses, and their
    Clients MUST conform to the
    [GA4GH AAI Specification](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md)
    requirements for Embedded Tokens in their use of RI Claim Embedded Tokens.

-   Validation, as outlined elsewhere in this specification and the
    GA4GH AAI Specification, MUST be performed before RI Claim
    Embedded Tokens are used for identity or authorization.

-   The "jti" is REQUIRED.

-   If the OIDC Access Token format is used (i.e. the "scope" claim
    contains the "openid" scope) as per the GA4GH AAI Specification's
    Embedded Token encoding options, then the /userinfo endpoint is unused
    but the /introspect endpoint MUST be available for
    [claim polling](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#claim-polling).

### RI Claim Embedded Token Format

```
{
  "typ": "JWT",
  "alg": "RS256",
  ["jku": "\<JKS URL\>",]
  "kid": "\<Key Identifier\>"
}.
{
  "iss": "\<Issuer URL\>",
  "sub": "\<Subject\>",
  ["scope": "openid ...",]
  "jti": "\<JTI Token Identifier\>",
  "iat": \<Seconds since epoch\>,
  "exp": \<Seconds since epoch\>,
  "ga4gh_rio": {
    "value": "\<Value String\>",
    "source": "\<Source URL\>",
    ["condition": {...},]
    ["by": "\<By identifier\>"]
  }
}.\<Signature\>
```

Where fields within the `ga4gh_rio` object are as described in the
[RI Claim Object Fields](#ri-claim-object-fields) section of this
specification except for "iat" and "exp" which are direct claims on
the outer JWT itself.

One of `scope` or `jku` MUST be present as described in
[RI Claim Embedded Token Requirements](#ri-claim-embedded-token-requirements).

#### "**iat**"

-   Shortened name for "issued at".

-   REQUIRED. Seconds since unix epoch of when the [Claim Source](#claim-source)
    that made the claim (i.e. the entity identified by the [source](#source)
    field and potentially more specific using the optional [by](#by)
    field, if present).

-   Its use by a Claim Clearinghouse is described in the
    [Claim Expiry](#claim-expiry) section.

#### "**exp**"

-   REQUIRED. Generally, it is seconds since unix epoch of when the
    [Claim Source](#claim-source) requires such a claim to be no longer
    valid. A Claim Source MAY choose to make a claim very long lived.
    However, a
    [Claim Signatory](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#term-embedded-claim-signatory)
    MAY choose an earlier timestamp if it wishes to limit the claim’s
    duration of use within downstream Claim Clearinghouses.

-   Represents the expiry of the individual claim itself, not the token that
    carries it.

-   Access is NOT necessarily removed by the "exp" timestamp. Instead, this
    timestamp may be viewed as a cut-off after which no new access will be
    granted and action to remove any existing access may commence anytime
    shortly after this cut-off period.

-   Its use by a Claim Clearinghouse is described in the
    [Claim Expiry](#claim-expiry) section and
    [Token Revocation](#claim-and-token-revocation) section.

## RI Claim Object Fields

Fields within a [RI Claim Object](#ri-claim-object) are:

#### "**value**"

-   REQUIRED. A string that represents the type, process and version of the claim. The
    format of the string can vary by the
    [claim definition](#ga4gh-researcher-identity-claim-definitions).

-   For example, ga4gh.ResearcherStatus.value =
    "<https://doi.org/10.1038/s41431-018-0219-y>” represents the Registered
    Access Bona Fide researcher status.

-   For the purposes of enforcing its policies for access, a Claim Clearinghouse
    evaluating the "value" field MUST:
    
    -   Validate URL strings as per the RI URL Field requirements.
    
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

-   OPTIONAL. A condition on an RI Claim Object indicates that the RI Claim
    Embedded Token is only valid if the contents of the condition are present
    elsewhere in the [Passport](#passport) and such content is both valid
    (e.g. hasn’t expired; signature of embedded token has been verified against
    the public key; etc.) and such content is accepted by the Claims
    Clearinghouse (e.g. the issuer is trusted; the source field meets any policy
    criteria that has been established, etc.).

-   A Claim Clearinghouse MUST always check for the presence of
    the condition field and if present it MUST only accept the RI Claim Object
    if it can confirm that the condition has been met.

-   In the process of finding a matching condition, a Claim Clearinghouse
    SHOULD ignore RI Claim Objects that also have a condition, or otherwise MUST
    avoid deep nesting of condition evaluation (i.e. avoid condition loops,
    stack overflows, etc).

-   Fields that are not specified in the condition are not required to match
    (i.e. any value will be accepted within that field).

-   Format:

```
"condition": {
  "\<ClaimName1\>" : {
    "\<FieldName1\>": [
      "\<Value1a\>",
      "\<Value1b\>"
    ],
    "\<FieldName2\>": ["\<Value2\>"],
    ...
  },
  "\<ClaimName2\>" : { ... }
}
```

-   Condition fields are restricted to only RI Claim Object Field names
    (e.g. "value", "source", etc.), except that it MUST NOT include "condition"
    (i.e. a condition cannot be placed on another condition).

    -   Note that the "source" in the condition is the expected source of the
        condition’s claim name and value, and is not the source of the claim to
        which the condition is attached.

    -   For example, "claimNameA.sourceA" asserts that "sourceA" is the
        [Claim Source](#claim-source) of "claimNameA" whereas
        "claimNameA.condition.claimNameB.sourceB" expects that "claimNameB"
        exists elsewhere in the Passport and is provided by "sourceB".

-   The Claim Clearinghouse MUST verify that for each condition claim and each
    condition field present, a single corresponding
    [RI Claim Object](#researcher-identity-claim-object-ri-claim-object) and its
    corresponding [fields](#claim-object-fields) match as per the matching
    algorithms described elsewhere in this specification, along with the
    following requirements:

    -   Checking the correctness of the condition MUST be performed first. For
        example, the field name but be a valid choice.

    -   A condition field matches when any one string within the specified list
        matches a corresponding claim’s field in the Passport.

    -   All condition fields that are specified MUST match the same RI Claim Object
        in the Passport.

    -   For example:

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
RI Claim Object that has any of the following:

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

A [RI Claim Object Field](#ri-claim-object-fields) that is defined as being of URL
format with the following limitations:

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

### Claim Expiry

In addition to any other policy restrictions that a Claim Clearinghouse may
enforce, Claim Clearinghouses that provide access for a given duration provided
by the user (excluding any revocation policies) MUST enforce one of the
following algorithm options to ensure that claim expiry is accounted for:

**Option A**: use the following algorithm to determine if the RI Claim Embedded Token is
valid for the entire duration of the requested duration:

```
now()+requestedTTL < min("claim.exp", "claim.iat"+maxAuthzTTL)
```

Where:

-   `requestedTTL` represents the duration for which access is being requested.
    Alternatively a solution may choose to have a stronger revocation policy
    instead of requiring such a duration.

-   `maxAuthzTTL` represents any additional expiry policy that the Claim
    Clearinghouse may choose to enforce. If this is not needed, it can
    effectively ignored by using a large number of years or otherwise have
    "claim.iat"+maxAuthzTTL removed and simplify the right hand side
    expression accordingly.

**Option B**: if tokens are sufficiently short lived and the authorization
system has an advanced revocation scheme that does not need to specify a
maxAuthzTTL as per Option A, then the check can be simplified:

```
now()+accessTokenTTL < claim.exp
```

Where:

-   `accessTokenTTL` represents the duration for which an access token will be
    accepted and is bounded by the next refresh token cycle and/or any larger
    propagation delay before access is revoked, which needs to be assessed based
    on the revocation model.

## GA4GH Researcher Identity Claim Definitions

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

-   The URLs SHOULD resolve to a human readable web page that describes the
    terms and policies. The description MUST be readable within the environment
    where the claims are consumed.

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

-   The identity as indicated by the {"iss", "sub"} pair (aka "[RI Claim
    Object Identity](#ri-claim-object-identity)") of the RI Claim Object is
    the same as the identities listed in the "[value](#value)" field.

-   The "[value](#value)" field format is a comma-delimited list of
    "<uri-encoded-sub>|<uri-encoded-iss>" entries with no added whitespace
    between entries.
  
    -   The "iss" and "sub" that are used to encode the "value" field do
        not need to conform to [URL Claim Field](#url-claim-fields)
        requirements since they must match the corresponding RI Claim
        Object "iss" and "sub" fields that may be issued.
        
    -   By URI encoding the "iss", special characters (such as "|" and ",")
        are encoded within the URL without causing parsing conflicts.
        
    -   Example:
        "sub1|https%3A%2F%2Fexample.org%2Fa%7Cb%2Cc,sub2|https%3A%2F%2Fexample2.org".

-   The "[source](#source)" field refers to the [Claim Source](#claim-source)
    that is making the assertion, which is often the same organization as the
    [Claim Signatory](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#term-embedded-claim-signatory)
    "iss" that signs the RI Claim Object but the "source" MAY refer to another
    Claim Source.

-   For example, if a policy needs 3 claims and there are three matching RI
    Claim Objects that meet the criteria on one Passport but they use 3
    different "sub" values ("sub1", "sub2", "sub3"), then **any** of the
    following, if from a trusted issuers and sources, may allow these
    claims to be combined (here shown without the REQUIRED URI-encoding
    in order to improve readability of the example).
    
    1. One RI Claim Object that links 3 RI Claim Object Identities
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
    
    2. One RI Claim Object that links a superset of RI Claim Object
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
    
    3. Multiple RI Claim Objects that chain together a set or superset
       of RI Claim Object Identities.
    
       ```
       {
         "iss": "https://example1.org/oidc",
         "sub": "sub1",
         "ga4gh_rio": {
           "value": "sub2|https://example2.org/oidc",
           "source": "https://example1.org/oidc"
         }
       },
       {
         "iss": "https://example2.org/oidc",
         "sub": "sub2",
         "ga4gh_rio": {
           "value": "sub3|https://example3.org/oidc",
           "source": "https://example2.org/oidc"
         }
       }
       ```

## Custom Researcher Identity Claim Names

-   In addition to the
    [standard GA4GH Researcher Identity Claim Definitions](#ga4gh-researcher-identity-claim-definitions),
    authorization claims MAY be added using custom claim names so long as the
    encoding of RI Claim Embedded Tokens abides by the requirements described elsewhere
    in this specification.

-   The custom claim name MUST follow the format prescribed in the
    [URL Claim Fields](#url-claim-fields) section of the specification.

-   Implementers introducing a new custom claim name MUST coordinate with the
    DURI committee to align custom claim use cases to maximize interoperability
    and avoid fragmentation across implementations.

-   Claim Clearinghouses MUST ignore custom claims that they do not support.

-   Non-normative example custom claim name:
    "https://dbgap.nih.gov/riClaims/researcherStudies".

## Encoding Use Cases

Use cases include, but are not limited to the following:

### Registered Access

-   To meet the requirements of
    [Registered Access](https://doi.org/10.1038/s41431-018-0219-y) to
    data, a user needs to have **all** of the following claims:

    -   Meeting the ethics requirements is represented by
        ga4gh.AcceptedTermsAndPolicies.value= \
        "<https://doi.org/10.1038/s41431-018-0219-y>"

    -   Meeting the bona fide status is represented by
        ga4gh.ResearcherStatus.value= \
        "<https://doi.org/10.1038/s41431-018-0219-y>"

-   The [Claim Clearinghouse](#claim-clearinghouse) (e.g. to authorize a
    registered access beacon) needs to evaluate the multiple claims listed above
    to ensure their values match before granting access.

### Controlled Access

-   Controlled Access to data MAY make use of any of the following RI claims:

    -   [ga4gh.ControlledAccessGrants](#ga4ghcontrolledaccessgrants) for
        permissions associated with specific data or datasets.
        
    -   [ga4gh.AffiliationAndRole](#ga4ghaffiliationandrole) to associate a user
        with a role within a specific organization. Additionally the
        ga4gh.ControlledAccessGrants MAY make use of the role and affiliation
        through a [condition](#condition) field.
        
    -   Any other RI claim that may be required to meet controlled access policies.

## Claim and Token Revocation

As per the
[GA4GH AAI Specification on Token Revocation](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#token-revocation),
the following mechanisms are available within RI Claim Embedded Tokens:

1.  RI Claim Embedded Tokens have an "[iat](#iat)" field to allow downstream
    policies to limit the life, if needed, of how long assertions will be
    accepted for use with access and refresh tokens.

2.  RI Claim Embedded Tokens have an "[exp](#exp)" field to allow Claim
    Clearinghouses to limit the life of access and refresh tokens.

At a minimum, these RI Claim Embedded Token fields MUST be checked by all Claim Clearinghouses
and systems MUST be in place to take action to remove access by the expiry
timestamp or shortly thereafter. Propagation of these permission changes may
also require some reasonable delay.

Systems implementing RI Claims MAY also employ other mechanisms outlined in the
GA4GH AAI Specification. Systems employing RI Claims MUST provide mechanisms to
limit the life of access, and specifically MUST conform to the GA4GH AAI
Specification requirements in this regard.

## Example RI Claims

This non-normative example illustrates RI claims representing Registered Access
bona fide researcher status along with RI claims for access to specific
Controlled Access data. These RI Claims would form a Passport when an Identity
Broker signs a Passport Access Token and makes these claims available via the
/userinfo endpoint. The claims for this example are:

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
        mechanism to check affiliation and role, so it makes use of the RI
        "[condition](#condition)" mechanism to
        enforce the affiliation and role. The dataset 432 claim is only valid if
        accompanied with a valid AffiliationAndRole claim for
        "faculty\@med.stanford.edu".

-   **AcceptedTermsAndPolicies**: The person has accepted the Ethics terms and
    conditions as defined by Registered Access. They took this action
    themselves.

-   **ResearcherStatus**: A Signing Official at Stanford Medicine has asserted
    that this person is a bona fide researcher as defined by Registered Access.

-   **LinkedIdentities**: An Identity Broker at example3.org has provided
    software functionality to allow a user to link their own accounts together.
    After the user has successfully logged into the two accounts and passed any
    auth challenges, the broker added the **LinkedIdentities** claim for those
    two accounts: (1) "10001" from example1.org, and (2) "abcd" from example2.org.
    Since the Identity Broker is signing this LinkedIdentities
    [RI Claim Embedded Token](#researcher-identity-claim-embedded-token-ri-claim-embedded-token),
    it is acting as the
    [Claim Signatory](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#term-embedded-claim-signatory).

Normally a Passport like this would include
[RI Claim Embedded Token Format](#ri-claim-embedded-token-format) entries
as base64 strings, but to show how claims carrying multiple RI Claim Embedded Tokens
can be encoded in a reader-friendly way, this example show the result
after the Embedded Tokens from the /userinfo endpoint has been unencoded into
JSON.

```
"ga4gh": {
  "AffiliationAndRole": [
    {
      "iat": 1549680000,
      "exp": 1581208000,
      ...
      "ga4gh_rio": {
        "value": "faculty@med.stanford.edu",
        "source": "https://grid.ac/institutes/grid.240952.8",
        "by": "so"
      }
    }
  ],
  "ControlledAccessGrants": [
    {
      "iat": 1549632872,
      "exp": 1581168872,
      ...
      "ga4gh_rio": {
        "value": "https://nih.gov/dbgap/phs000710",
        "source": "https://grid.ac/institutes/grid.48336.3a",
        "by": "dac"
      }
    },
    {
      "iat": 1549640000,
      "exp": 1581168000,
      ...
      "ga4gh_rio": {
        "value": "https://ega-archive.org/datasets/00000432",
        "source": "https://grid.ac/institutes/grid.225360.0",
        "condition": {
          "ga4gh.AffiliationAndRole" : {
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
      "iat": 1549680000,
      "exp": 1581208000,
      ...
      "ga4gh_rio": {
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
      "iat": 1549680000,
      "exp": 1581208000,
      ...
      "ga4gh_rio": {
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
      "iat": 1549680000,
      "exp": 1581208000,
      ...
      "ga4gh_rio": {
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

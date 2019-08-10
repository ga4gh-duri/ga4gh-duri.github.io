--------------------------------------------------------------------------------

# GA4GH Researcher Identity & Access Claims (FROZEN RFC)

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
  - [Researcher Identity Claim (“RI Claim”)](#researcher-identity-claim-ri-claim)
  - [Researcher Identity Claim Object (“RI Claim Object”)](#researcher-identity-claim-object-ri-claim-object)
  - [Claim Authority](#claim-authority)
  - [Root Claim Broker](#root-claim-broker)
  - [Passport](#passport)
  - [Claim Clearinghouse](#claim-clearinghouse)
- [**Researcher Identity Claim Overview**](#researcher-identity-claim-overview)
  - [RI Claims Requirements](#ri-claims-requirements)
  - [Support for User Interfaces](#support-for-user-interfaces)
- [**Claim Objects**](#claim-objects)
  - [Claim Object Fields](#claim-object-fields)
    - [value](#value-required)
    - [source](#source-required)
    - [asserted](#asserted-required)
    - [expires](#expires-required)
    - [condition](#condition-optional-on-specific-ri-claims)
    - [by](#by-optional)
  - [URL Claim Fields](#url-claim-fields)
  - [Claim Expiry](#claim-expiry)
- [**GA4GH Researcher Identity Claim Definitions**](#ga4gh-researcher-identity-claim-definitions)
  - [ga4gh.AffiliationAndRole](#ga4ghaffiliationandrole)
  - [ga4gh.AcceptedTermsAndPolicies](#ga4ghacceptedtermsandpolicies)
  - [ga4gh.ResearcherStatus](#ga4ghresearcherstatus)
  - [ga4gh.ControlledAccessGrants](#ga4ghcontrolledaccessgrants)
- [**Embedded Passport Tokens**](#embedded-passport-tokens)
  - [Token Endpoint](#token-endpoint)
  - [Example with Embedded Tokens](#example-with-embedded-tokens)
- [**User Info Endpoint**](#user-info-endpoint)
- [**Encoding Use Cases**](#encoding-use-cases)
  - [Public Access](#public-access)
  - [Registered Access](#registered-access)
  - [Controlled Access](#controlled-access)
- [**Claim and Token Revocation**](#claim-and-token-revocation)
- [**Example RI Claims**](#example-ri-claims)
- [**Specification Revision History**](#specification-revision-history)

## Conventions and Terminology

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be
interpreted as described in [RFC 2119](https://tools.ietf.org/html/rfc2119).

Additonal terms on fields:

-   **[required]**: A field that MUST be present within a
    [Claim Object](#claim-object-fields).
-   **[optional]** : A field that MAY be present within a
    [Claim Object](#claim-object-fields).
-   **[optional on specific RI claims]** : A field that MAY be present only on
    claims when where the claim definition explicitly mentions that this field
    MAY be specified. All other claims MUST NOT define this field.

#### **Researcher Identity Claim (“RI Claim”)**

-   A set of [RI Claim Objects](#researcher-identity-claim-object-ri-claim-object)
    provided by a common key value within the "ga4gh" OIDC claim. For example, the
    following structure encodes a "ga4gh.ControlledAccessGrants" RI Claim:
    
    ```
    "ga4gh" : {
      "ControlledAccessGrants": [
        Claim Object (see definition below),
        Claim Object (if more than one),
        ...
      ]
    }
    ```
    
    RI Claims can be bundled together in a [Passport](#passport).

#### **Researcher Identity Claim Object ("RI Claim Object")**

-   An Assertion from [Claim Authority](#claim-authority) that is bound to a
    researcher identity.

-   Encoded as a JSON object that contains various properties
    ([Claim Object Fields](#claim-object-fields)) that describe the assertion and
    limitations thereof.

#### **Claim Authority**

-   The [source](#source-required) of a claim assertion which at a minimum
    includes the organization associated with asserting the claim, although can
    optionally identify a sub-organization or a specific [role](#by-optional)
    within the organization that made the claim.

-   This is NOT necessarily the organization that stores the claim, nor the
    [Identity Broker](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#term-identity-broker)’s
    organization that signs the [passport](#passport); it is the organization
    that has the authority to assert the claim on behalf of the user and is
    responsible for making and maintaining the assertion.

#### **Root Claim Broker**

-   The original
    [Identity Broker](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#term-identity-broker)
    that encodes an RI Claim Object directly from a Claim Authority or directly
    from a data store that contains a Claim Authority’s assertion is the Root
    Claim Broker for that RI Claim Object.

-   For example, an Identity Broker that reads assertions from a SQL database
    and presents them in a Passport is the Root Claim Broker for such RI Claim
    Objects whereas an Identity Broker that receives an RI Claim Object from an
    upstream Identity Broker and propagates it within a new Passport is not the
    Root Claim Broker.

#### **Passport**

-   A bundle of
    [researcher identity claims](#researcher-identity-claim-ri-claim) that is
    collected into a
    [specialized JWT token](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#ga4gh-jwt-format)
    and signed by an
    [Identity Broker](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#term-identity-broker)
    as per the
    [GA4GH AAI specification](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md)
    for the purpose of encoding identity and evaluating authorization.

-   The bundle of claims includes any indirect RI Claims that such a JWT token
    makes available to the caller of the corresponding /userinfo endpoint, as
    well as any RI Claims that may be collected either directly on JWTs provided
    within the “ga4gh_passports” object or within responses to the /userinfo
    endpoints for the “ga4gh_passports” tokens.

-   The bundle of claims includes all RI Claims made available to recursive
    calls to /userinfo following other embedded Passport tokens that are present
    within its claims.


#### **Embedded Passport Token ("Embedded Token")**

-   A Passport token that is included as part of a “ga4gh_passports” claim
    within another Passport.

-   For example, Passport Token 1’s /userinfo endpoint may return a
    “ga4gh_passports” claim with a set of signed JWT token strings (token 2,
    token 3). In this case, Passport Token 2 and 3 are said to be Embedded
    Tokens within Passport Token 1 even though the embedded tokens are not
    directly encoded in the Passport Token 1’s Access Token payload itself
    (i.e. a /userinfo call is required to fetch the “ga4gh_passports” claim).

-   See the [Embedded Passport Tokens](embedded-passport-tokens) section for
    more details.

#### **Claim Clearinghouse**

-   The service consuming claims via a [Passport](#passport) as defined by
    the
    [Claim Clearinghouses section of the GA4GH AAI specification](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#conformance-for-claim-clearinghouses-consuming-access-tokens-to-give-access-to-data).

## Researcher Identity Claim Overview

### RI Claims Requirements

1.  <a name="requirement-1"></a>
    [RI Claims](#researcher-identity-claim-ri-claim) and tokens that contain RI
    Claims MUST conform the the
    [GA4GH AAI Spec](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md).

2.  <a name="requirement-2"></a> Each RI Claim consists of a list of [Claim Objects](#claim-object-fields).

3.  <a name="requirement-3"></a> Each RI Claim Object may have a different expiry.

    -   This allows a token carrying the claims to be short lived (e.g. 10
        minutes).

    -   The same document can encode claims for any
        [Claim Clearinghouse](#claim-clearinghouse) to evaluate when requesting
        pre-authorization for a longer duration (e.g. a request can establish
        intent to access a resource over the next 60 days, even if this access
        ends up being revoked after 15 days for other reasons).

4.  <a name="requirement-4"></a> RI Claim Objects MUST have an indication of which
    organization asserted the claim (i.e. the “[source](#source-required)”
    field), but RI Claim Objects do not indicate individual persons involved in making the
    assertion (i.e. who assigned/signed the claim) as it is not generally needed
    to make an access decision.

5.  <a name="requirement-5"></a> Additional information about claims that is not
    needed to make an access decision SHOULD not be included in the claim.
    Auditing and other purposes are not the intent of these standard RI Claims,
    and must be handled via another means beyond the scope of this specification
    with sufficient authority to expose such information.

6.  <a name="requirement-6"></a> All RI Claims within the “ga4gh” scope eligible
    for release to the requestor MUST be provided. Reasons for limiting exchange
    may include user approval, contractual limitations, regulatory restrictions,
    or filtering claims to only the subset needed for a particular purpose, etc.

7.  <a name="requirement-7"></a> When an
    [Identity Broker](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#term-identity-broker)
    receives a request with the “ga4gh” scope, it MUST provide RI claims under
    the “ga4gh” OIDC claim as follows:

    -   The Identity Broker collects the claims, potentially from multiple
        sources including any upstream Identity Brokers.

    -   The Identity Broker introduces new RI Claim Objects as a Root Claim
        Broker by encoding objects within the "ga4gh" OIDC claim whereas the
        Identity Broker propagates RI Claims that it received from upstream
        brokers using
        [Embedded Passport Tokens](#embedded-passport-tokens).

    -   The Identity Broker MUST NOT include claims from upstream Identity
        Brokers as part of the "ga4gh" OIDC claim unless the Identity Broker
        wishes to follow an implicit trust security model and take
        responsibility for presenting those upstream claims to a specific
        audience. For example, an organization may provide an
        intraorganizational security service that filters and flattens all
        claims that meet that organization’s security and trust model on behalf
        of many Claims Clearinghouses within that organization where each such
        client of this service places absolute trust in its ability to filter
        claims into a flattened claim set that gets signed as a Passport.

    -   The Identity Broker signs the token of claims.

    -   Note: an Identity Broker, by signing a Passport provides its authority
        that such claims were collected correctly, are ligitimently derived from
        the sources of authority, and are presented accurately.

8.  <a name="requirement-8"></a> RI Claims are designed for machine
    interpretation only to make an access decision and is a non-goal to support
    rich user interface requirements nor do these claims fully encode the audit
    trail.

9.  <a name="requirement-9"></a> An RI Claim Object MAY contain a
    "[condition](#condition-optional-on-specific-ri-claims)" field that
    restricts the RI Claim Object to only be valid when the condition is met.

    -   For example, an identity can have several affiliations and a
        ControlledAccessGrants RI Claim Object MAY be coupled to one of them
        using the Condition field.

10. <a name="requirement-10"></a> Processing a Passport within a Claims
    Clearinghouse is to abide by the following:

    -   A Claims Clearinghouse MUST ignore Passports, including [Embedded
        Passport Tokens](#embedded-access-token), unless it explicitly has a
        sufficient trust relationship with the issuer and has verified the
        token’s signature.

    -   A Claims Clearinghouse MUST ignore all RI Claim Objects is does not need
        to process a particular request and MUST ignore all RI Claim Objects
        unless it explicitly has a sufficient trust relationship with the
        "[source](#source-required)" of the RI Claim Object.

    -   In addition to policy or token validity reasons as indicated elsewhere
        in this specification and the AAI specification (such as the token may
        be rejected if it is not formatted to specification), a Passport MAY be
        rejected if the Claims Clearinghouse has not established a trust
        relationship the broker that signed it.

    -   Claims Clearinghouses SHOULD ignore claims that aren’t needed for their
        purposes and also MUST ignore tokens from untrusted sources.

11. <a name="requirement-11"></a> The user represented by the identity of the
    token MUST have agreed to release claims related to the requested scopes as
    part of generating tokens that can expose RI claims. Identity Brokers MUST
    adhere to
    [section 3.1.2.4 of the OIDC specification](https://openid.net/specs/openid-connect-core-1_0.html#Consent).

    -   The user represented by a Researcher Identity MUST approve the release
        of GA4GH RI Claims to relying parties with sufficient granularity to
        allow for responsible disclosure of information best practices as well
        as to meet privacy regulations that may be applicable within or between
        jurisdictions where the user’s identity will be used (e.g. GDPR for
        a European Union user).

    -   If the user’s release agreement has been remembered as part of a user’s
        settings such that the user no longer needs to be prompted, then the
        user MUST have the ability to remove this setting (i.e. be prompted
        again in the future). If a feature is to bypass prompts by remembering
        settings is available, it MUST only be used as an opt-in feature with
        explicit controls available to the user.

    -   The withdrawal of this agreement does not need to impact previously
        generated tokens.

### Support for User Interfaces

(e.g. mapping a URI string to a human-readable description for a user
interface.)

For example, a user interface mapping of
“<https://doi.org/10.1038/s41431-018-0219-y>” to a human readable description
such as “this person is a bona fide researcher as described by the Global
Alliance for Genomics and Health”.

Support for User Interfaces is not part of this specification. It is a non-goal
for this specification to consider the processes that would support user
interfaces, such as:

-   String definitions could be provided as a community effort (e.g. on a wiki)
    if there is some assurance that definitions have not been tampered with.

-   Any such open effort could be made easy to update and allow self-register
    new string mappings (e.g. affiliation domain name to research organization
    name)

-   May provide a rich set of internationalization/localization features for
    clients to consume.

## Claim Objects

Each [RI claim](#researcher-identity-claim-ri-claim) name maps to an array of
claim JSON objects ([RI Claim Objects](#researcher-identity-claim-object-ri-claim-object))
within a “ga4gh” root OIDC claim object (see [example](#example-ri-claims)).

## Claim Object Fields

Fields within a RI Claim Object are:

#### “**value**” [required]

-   A string that represents the type, process and version of the claim. The
    format of the string can vary by the
    [claim definition](#ga4gh-researcher-identity-claim-definitions).

-   For example, ga4gh.ResearcherStatus.value =
    "<https://doi.org/10.1038/s41431-018-0219-y>” represents the Registered
    Access Bona Fide researcher status.

-   A Claim Clearinghouse SHOULD match the full string value as part of
    enforcing its policies for access.

#### “**source**” [required]

-   A [URL Claim Field](#url-claim-fields) that provides at a minimum the
    organization that has asserted the claim. If there is no organization
    asserting a claim, the “source” MUST be set to
    "https://ga4gh.org/duri/no_org”.

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

#### “**asserted**” [required]

-   Shortened name for “asserted at”.

-   Seconds since unix epoch of when the [Claim Authority](#claim-authority)
    that made the claim (i.e. the entity identified by the [source](#source-required)
    field and potentially more specific using the optional [by](#by-optional)
    field, if present).

-   Its use by a Claim Clearinghouse is described in the
    [Claim Expiry](#claim-expiry) section.

#### “**expires**” [required]

-   Generally, it is seconds since unix epoch of when the
    [Claim Authority](#claim-authority) requires such a claim to be no longer
    valid. A Claim Authority MAY choose to make a claim very long lived.
    However, an Identity Broker MAY choose an earlier timestamp if it wishes to
    limit the claim’s duration of use within downstream Claim Clearinghouses.

-   Represents the expiry of the individual claim itself, not the token that
    carries it.

-   Access is NOT necessarily removed by the `expires` timestamp. Instead, this
    timestamp may be viewed as a cut-off after which no new access will be
    granted and action to remove any existing access may commence anytime
    shortly after this cut-off period.

-   Its use by a Claim Clearinghouse is described in the
    [Claim Expiry](#claim-expiry) section and
    [Token Revocation](#claim-and-token-revocation) section.

#### “**condition**” [optional on specific RI claims]

-   A condition on an RI Claim Object indicates that the RI Claim Object is only
    valid if the contents of the condition are present elsewhere in the
    [Passport](#passport) and such content is both valid (e.g. hasn’t expired;
    signature of embedded token has been verified against the public key; etc.)
    and such content is accepted by the Claims Clearinghouse (e.g. the issuer is
    trusted; the source field meets any policy criteria that has been
    established, etc.).

-   A condition on an RI Claim Object indicates that the RI Claim Object is
    only valid if the contents of the condition are present elsewhere in the
    Passport.

-   Fields that are not specified in the condition are not required to match
    (i.e. any value will be accepted within that field).

-   [Embedded Passport Tokens](#embedded-passport-tokens) (including those that
    are nested within the limits and trust model set out elsewhere in this
    specification) SHOULD be included as needed to satisfy a condition, but such
    tokens that are not from trusted Identity Brokers or that do not have
    relevant RI Claim Objects can be safely ignored.

-   Format:

```
"condition": {
  "ClaimName1" : {
    "FieldName1": [
      "Value1a",
      "Value1b"
    ],
    "FieldName2": ["Value2"],
    ...
  },
  "{ClaimName2}" : { ... }
}
```

-   Condition fields are restricted to only “[value](#value-required)”,
    “[source](#source-required)”, and “[by](#by-optional)” fields (i.e.
    timestamp fields and conditions on conditions are not permitted).

    -   Note that the “source” in the condition is the expected source of the
        condition’s claim name and value, and is not the source of the claim to
        which the condition is attached.

    -   For example, “claimNameA.sourceA” asserts that “sourceA” is the
        [Claim Authority](#claim-authority) of “claimNameA” whereas
        “claimNameA.condition.claimNameB.sourceB” expects that “claimNameB”
        exists elsewhere in the passport and is provided by “sourceB”.

-   The Claim Clearinghouse MUST verify that for each condition claim and each
    condition field present, a single corresponding
    [RI Claim Object](#researcher-identity-claim-object-ri-claim-object) and its
    corresponding [fields](#claim-object-fields) match as per the matching
    algorithms described elsewhere in this specification, along with the
    following requirements:

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

> Would match a corresponding AffiliationAndRole claim within the same passport
> that has any of the following:

-   value = "faculty\@uni-heidelberg.de" AND by = "so"

-   value = "faculty\@uni-heidelberg.de" AND by = "system"

-   value = "student\@uni-heidelberg.de" AND by = "so"

-   value = "student\@uni-heidelberg.de" AND by = "system"

-   The Condition field MUST NOT be present within a RI Claim Object unless a
    [claim’s definition](#ga4gh-researcher-identity-claim-definitions)
    explicitly indicates it is optional or required.

#### “**by**” [optional]

-   The level or type of authority within the “source” organization that is
    asserting the claim.

-   A Claim Clearinghouse MAY use this field as part of an authorization
    decision based on the policies that it enforces.

-   Fixed vocabulary values for this field are:

    -   **self**: The identity for which the claim is being made and the person
        who made the claim is the same person.

    -   **peer**: A person, who has the same ResearcherStatus as this claim, has
        made this assertion. The “source” field represents the peer’s
        organization that is asserting the claim (which isn’t necessarily the
        same as the identity’s home organization).

    -   **system**: The person’s home organization’s information system has
        asserted the claim.

    -   **so**: The person (also known as “signing official”) who authorized
        this claim is within the “source” organization and at the time the claim
        was issued possessed direct authority (as part of their formal duties)
        to bind the organization to their assertion that the identity has met
        the policies indicated by this claim within the context of its “value”
        field.

    -   **dac**: A Data Access Committee or other authority that is responsible
        as a grantee decision-maker for the given “value” and “source” field
        pair.

-   If this field is not provided, then none of the above values can be assumed
    as the level or type of authority is “unknown”. Any policy expecting a
    specific value as per the list above MUST fail to accept an “unknown” value.

### URL Claim Fields

A [claim object field](#claim-object-fields) that is defined as being of URL
format with the following limitations:

1.  For the purposes of evaluating access, the URL MUST be treated as a simple
    unique persistent string identifier.

2.  The URL is a canonical identifier and as such it is important that Claim
    Clearinghouses MUST match this identifier consistently using a
    case-sensitive full string comparison.

    -   Note that these URLs SHOULD use “https” in a canonical identifier even
        if the human readable document will resolve using either scheme.

    -   Research institutions are encouraged to use a persistent URL pointing to
        established organizational ontology URL such as a
        [GRID URL](https://grid.ac/institutes) as their canonical “source” URL.

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

**Option A**: use the following algorithm to determine if the RI Claim Object is
valid for the entire duration of the requested duration:

```
now()+requestedTTL < min("claim.expires", "claim.asserted"+maxAuthzTTL)
```

Where:

-   `requestedTTL` represents the duration for which access is being requested.
    Alternatively a solution may choose to have a stronger revocation policy
    instead of requiring such a duration.

-   `maxAuthzTTL` represents any additional expiry policy that the Claim
    Clearinghouse may choose to enforce. If this is not needed, it can
    effectively ignored by using a large number of years or otherwise have
    "claim.asserted"+maxAuthzTTL removed and simplify the right hand side
    expression accordingly.

**Option B**: if tokens are sufficiently short lived and the authorization
system has an advanced revocation scheme that does not need to specify a
maxAuthzTTL as per Option A, then the check can be simplified:

```
now()+accessTokenTTL < claim.expires
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

        -   Example: <faculty@cam.ac.uk>

        -   Note: based on the eduPerson specification, it is possible that
            institutions use a different definition for the meaning of "faculty"
            ranging from "someone who does research", to "someone who teaches",
            to "someone in education that works with students".

    -   A custom role that includes a namespace prefix followed by a dot (“.”)
        where the implementers coordinate with the DURI committee to ensure that
        the namespace does not conflict with other implementations and that the
        vocabulary is not already defined by others.

        -   Example: “<nih.researcher@med.stanford.edu>” where “nih” is the
            namespace and “researcher” is the custom role within that namespace.

-   If there is no affiliated institution associated with a given claim, the
    affiliation portion of AffliationAndRole MUST be set to “no_org.ga4gh.org”.

    -   Example: “public.citizen-scientist\@no_org.ga4gh.org”

### ga4gh.AcceptedTermsAndPolicies

-   The set of unique identifiers in the form of URLs that indicate that a
    researcher or their organization has acknowledged the specific terms and
    conditions indicated by the URL.

-   The URLs SHOULD resolve to a human readable web page that describes the
    terms and policies. The description MUST be readable within the environment
    where the claims are consumed.

-   Example value: “<https://doi.org/10.1038/s41431-018-0219-y>” acknowledges
    the ethics terms as needed for
    [Registered Access](#registered-access) Bona Fide researcher
    status.

-   MUST include “[by](#by-optional)” field.

### ga4gh.ResearcherStatus

-   Unique identifiers in the form of URLs that indicate that the person has
    been acknowledged to be a researcher of a particular type or standard.

-   The “value” field of the claim indicates the minimum standard and/or type of
    researcher that describes the person represented by the given identity.

-   The URLs SHOULD resolve to a human readable web page that describes the
    process that has been followed and the qualifications this person has met.

-   Example value: “<https://doi.org/10.1038/s41431-018-0219-y>” acknowledges
    the registration process as needed for
    [Registered Access](#registered-access) Bona Fide researcher
    status.

### ga4gh.ControlledAccessGrants

-   A list of datasets or other objects for which controlled access has been
    granted to this researcher.

-   The “source” field contains the access grantee organization

-   MUST include “[by](#by-optional)” field.

-   This claim MAY include a
    “[condition](#condition-optional-on-specific-ri-claims)” field.

## Embedded Passport Tokens

-   When the "ga4gh_passports" scope is present, the Identity Broker MAY include
    [Embedded Passport Tokens](embedded-passport-token) as a response to the
    /userinfo endpoint and MAY include "ga4gh_passports" as a string entry in
    the "ga4gh_userinfo_claims" OIDC claim within the Access Token.

-   The "ga4gh_passports" claim has the following format where `<src_name>` is a
    variable:

    ```
    "ga4gh_passports": {
      "<src_name>": {
        "JWT": "<jwt_header.jwt_part2.jwt_part3>"
      }
    }
    ```

-   `<src_name>` SHOULD be defined by the Identity Broker as the "idp" claim
    within the JWT token format or be a path tracing back a chain of IdP names
    to the Claim Source’s Identity Broker
    ("<root_broker_idp_name>.<next_broker_idp_name>.<current_broker_idp_name>")
    whenever possible.

-   Claims within Embedded Passport Tokens are not valid unless all other
    Passport checks pass (such as the token hasn’t expired) as described
    elsewhere in this specification.

-   When collecting claims from a nested set of /userinfo endpoints, the client
    MUST detect and avoid fetch loops and avoid fetching redundant entries that
    may appear at any level in the chain of Embedded Passport Tokens. At a
    minimum, detection of redundant fetches MUST be based on the "iss" claim
    within a Passport (e.g. do not call /userinfo twice for the same "iss" to
    resolve the set of claims within a single Passport). Additional filtering
    MAY also be used.

-   When a client resolves a set of claims, it MUST limit the number of RPC
    calls to at most 20 /userinfo requests related to a single Passport,
    including both direct Embedded Passport Tokens and more deeply nested
    Embedded Passport Tokens.

-   Clients MAY use Passport tokens, including Embedded Passport Tokens, to
    occasionally check which claims are still valid at the associated /userinfo
    endpoint in order to establish whether the user still meets the access
    requirements. This MUST NOT be done more than once per hour. Any request
    retries MUST include exponential backoff delays based on best practices
    (e.g. include appropriate jitter). The client MUST stop checking once any of
    the following occurs:

    -   The user will no longer use these claims. For example, all downstream
        cloud tasks have terminated and the related systems will no longer be
        using the Passport nor any downstream tokens that were generated by
        inspecting the Passport.

    -   The token has expired as per the "exp" field.

    -   The user owning the identity or a system administrator has revoked the
        Passport token or a refresh token related to the Passport.

    -   The /userinfo endpoint returns an HTTP status that is not retryable.
        For example, the token has been revoked.

### Token Endpoint

Minting of Embedded Passport Tokens via the /token OIDC endpoint must adhere to
Passport requirements provided elsewhere in this specification as well as in the
GA4GH AAI specification, with the following caveats:

-   If the Identity Broker wishes to support open federation (i.e. the issuer
    does not need to know who the client will be), the Access Token SHOULD NOT
    include the "aud" claim. The Broker MAY include "aud" if it wishes to limit
    the use of the token to specific clients.

-   If a "ga4gh_userinfo_claims" on the Passport contains a string entry of
    "ga4gh_passports", then the /userinfo endpoint MAY have a "ga4gh_passports"
    claim.

### Example with Embedded Tokens

Passport:

```
{
  "iss": "http://identity-broker.example.org",
  "sub": "1111",
  "idp": "orcid",
  "scope": ["ga4gh", "ga4gh_passports"],
  ...
  "ga4gh_userinfo_claims": [
    "ga4gh.ResearcherStatus",
    "ga4gh_passports"
  ]
}
```

Identity Broker’s /userinfo endpoint for the Passport above:

```
"ga4gh" : {
  "ResearcherStatus": [
    ...
  ]
},
"ga4gh_passports" : {
  "elixir" : {
    "JWT": "part1.part2.part3"
  },
  "ega.elixir" {
    "JWT": "part1.part2.part3"
  },
}
```

Where “ega.elixir” Embedded Passport Token JWT body is:

```
{
  "iss": "http://elixir.example.org/oidc",
  "sub": "1234",
  "iat": 1000000000,
  "exp": 1002592000,
  "idp": "google",
  "scope": ["ga4gh", "ga4gh_passports"],
  "ga4gh_userinfo_claims": [
    "ga4gh.ControlledAccessGrants",
    "ga4gh_passports"
  ]
}
```

Note that the Embedded Passport Token above has another layer of Embedded
Passport Tokens within it, as indicated by it's "ga4gh_userinfo_claims" string
entry of "ga4gh_passports". This next layer of tokens can be fetched at `elixir.example.org`'s /userinfo endpoint using the `ega.elixir` Embedded
Passport Token above.

## User Info Endpoint

-   The Passport for the /userinfo request MUST contain the "ga4gh" scope in
    order to include the "ga4gh" OIDC claim as part of the response.

-   The Passport for the /userinfo request MUST contain the "ga4gh_passports"
    scope in order to include the "ga4gh_passports" OIDC claim as part of the
    response.

-   The Identity Broker MAY return a subset of embedded tokens.

    -   For example, the user may not agree to release the tokens, or the token
        may have expired, or the broker may wish to filter tokens if it is
        enforcing a particular trust model.

    -   Therefore the response from /userinfo may not have a "ga4gh_passports"
        claim even if the Passport’s "ga4gh_userinfo_claims" strings hinted that
        such a claim may have content.

## Encoding Use Cases

Use cases include, but are not limited to the following:

### Registered Access

-   To meet the requirements of
    [Registered Access](https://www.nature.com/articles/s41431-018-0219-y) to
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
        through a [condition](#condition-optional-on-specific-ri-claims) field.
        
    -   Any other RI claim that may be required to meet controlled access policies.

## Claim and Token Revocation

As per the
[GA4GH AAI Specification on Token Revocation](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#token-revocation),
the following mechanisms are available within RI Claim Objects:

1.  RI Claim Objects have an [asserted](#asserted-required) field to allow downstream
    policies to limit the life, if needed, of how long assertions will be
    accepted for use with access and refresh tokens.

2.  RI Claim Objects have an [expires](#expires-required) field to allow Claim
    Clearinghouses to limit the life of access and refresh tokens.

At a minimum, these RI Claim Object fields MUST be checked by all Claim Clearinghouses
and systems MUST be in place to take action to remove access by the expiry
timestamp or shortly thereafter. Propagation of these permission changes may
also require some reasonable delay.

Systems implementing RI Claims MAY also employ other mechanisms outlined in the
GA4GH AAI Specification. Systems employing RI Claims MUST provide mechanisms to
limit the life of access, and specifically MUST conform to the GA4GH AAI
Specification requirements in this regard.

If a Passport Access Token, including any Embedded Passport Token, is
long-lived, then the Passport Access Token MUST be revocable, and once revoked
the /userinfo endpoint MUST NOT return the "ga4gh" OIDC claim nor the
"ga4gh_passports" OIDC claim. In this event, an appropriate error status MUST be
returned as per
[section 5.3.3 of the OIDC specification](https://openid.net/specs/openid-connect-core-1_0.html#UserInfoError).

## Example RI Claims

This non-normative example illustrates RI claims representing Registered Access
bona fide researcher status along with RI claims for access to specific
Controlled Access data. These RI Claims would form a Passport when included in a
JWT that is signed by an Identity Broker:

-   **AffiliationAndRole**: The person is a member of faculty at Stanford
    University as asserted by a Signing Official at Stanford.

-   **ControlledAccessGrants**: The person has approved access by the DAC at the
    National Cancer Institute for datasets 710 and approval for dataset 432 for
    a dataset from EGA.

    -   In this example, assume dataset 710 does not have a
        “[condition](#condition-optional-on-specific-ri-claims)” based on the
        AffiliationAndRole because the system that is asserting the claim has an
        out of band process to check the researcher’s affiliation and role and
        withdraw the dataset 710 claim automatically, hence it does not need the
        condition to accomplish this.

    -   In this example, assume that dataset 432 does not use an out of band
        mechanism to check affiliation and role, so it makes use of the RI
        “[condition](#condition-optional-on-specific-ri-claims)” mechanism to
        enforce the affiliation and role. The dataset 432 claim is only valid if
        accompanied with a valid AffiliationAndRole claim for
        “faculty\@med.stanford.edu”.

-   **AcceptedTermsAndPolicies**: The person has accepted the Ethics terms and
    conditions as defined by Registered Access. They took this action
    themselves.

-   **ResearcherStatus**: A Signing Official at Stanford Medicine has asserted
    that this person is a bona fide researcher as defined by Registered Access.

    ```
    "ga4gh": {
    "AffiliationAndRole": [
      {
        "value": "faculty@med.stanford.edu",
        "source": "https://grid.ac/institutes/grid.240952.8",
        "by": "so",
        "asserted": 1549680000,
        "expires": 1581208000
      }
    ],
    "ControlledAccessGrants": [
      {
        "value": "https://nih.gov/dbgap/phs000710",
        "source": "https://grid.ac/institutes/grid.48336.3a",
        "by": "dac",
        "asserted": 1549632872,
        "expires": 1581168872
      },
      {
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
        "by": "dac",
        "asserted": 1549640000,
        "expires": 1581168000
      }
    ],
    "AcceptedTermsAndPolicies": [
      {
        "value": "https://doi.org/10.1038/s41431-018-0219-y",
        "source": "https://grid.ac/institutes/grid.240952.8",
        "by": "self",
        "asserted": 1549680000,
        "expires": 1581208000
      }
    ],
    "ResearcherStatus": [
      {
        "value": "https://doi.org/10.1038/s41431-018-0219-y",
        "source": "https://grid.ac/institutes/grid.240952.8",
        "by": "so",
        "asserted": 1549680000,
        "expires": 1581208000
      }
    ]
    }
    ```

## Specification Revision History

| Version | Date       | Editor                             | Notes                                                         |
|---------|------------|------------------------------------|------------------------------------------------------------------|
| 0.9.3   | 2019-08-09 | Craig Voisin                       | Updates related to introducing Embedded Passport Tokens       |
| 0.9.2   | 2019-07-09 | Craig Voisin                       | Introduce RI Claim Object definition and use it consistently  |
| 0.9.1   | 2019-07-08 | Craig Voisin                       | Clarify use cases, rephrase multi-value, update links         |
| 0.9.0   | 2017-      | Craig Voisin, Mikael Linden et al. | Initial working version                                       |

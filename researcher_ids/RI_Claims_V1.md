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
[use cases](#encoding-use-cases).

**Co-Chairs of Product Subgroup**: Stephanie Dyke (McGill) & Craig Voisin
(Google)

### Table of Contents

- [**Conventions and Terminology**](#conventions-and-terminology)
  - [Researcher Identity Claim (“RI Claim”)](#researcher-identity-claim-ri-claim)     
  - [Claim Authority](#claim-authority)
  - [Passport](#passport)
  - [Claim Clearinghouse](#claim-clearinghouse)
- [**Researcher Identity Claim Overview**](#researcher-identity-claim-overview)
  - [RI Claims Requirements](#ri-claims-requirements)
  - [Support for User Interfaces](#support-for-user-interfaces)
- [**Claim Object Fields**](#claim-object-fields)
  - Field Definitions:
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

-   An assertion from a [Claim Authority](#claim-authority) that is bound to a
    researcher identity. Claims have various properties or fields that describe
    the attestations and limitations thereof. These claims can then be bundled
    together in a [Passport](#passport).

#### **Claim Authority**

-   The [source](#source-required) of a claim assertion which at a minimum
    includes the organization associated with asserting the claim, although can
    optionally identify a sub-organization or a specific [role](#by-optional)
    within the organization that made the claim.

-   This is NOT necessarily the organization that stores the claim, or the
    [Identity Broker](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#term-identity-broker)’s
    organization that signs the [passport](#passport); it is the organization
    that has the authority to assert the claim on behalf of the user that is
    responsible for making and maintaining the assertion.

#### **Passport**

-   A bundle of
    [researcher identity claims](#researcher-identity-claim-ri-claim) that is
    collected into a
    [specialized JWT token](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#ga4gh-jwt-format)
    and signed by an
    [Identity Broker](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#term-identity-broker)
    as per the
    [GA4GH AAI specification](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md)
    for the purpose of evaluating authorization.

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

3.  <a name="requirement-3"></a> Each RI Claim object may have a different expiry.

    -   This allows a token carrying the claims to be short lived (e.g. 10
        minutes).

    -   The same document can encode claims for any
        [Claim Clearinghouse](#claim-clearinghouse) to evaluate when requesting
        pre-authorization for a longer duration (e.g. a request can establish
        intent to access a resource over the next 60 days, even if this access
        ends up being revoked after 15 days for other reasons).

4.  <a name="requirement-4"></a> RI Claims MUST have an indication of which
    organization asserted the claim (i.e. the “[source](#source-required)”
    field), but claims do not indicate individual persons involved in making the
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
    the “ga4gh” OIDC token claim as follows:

    -   The Identity Broker collects the claims, potentially from multiple
        sources including any upstream Identity Brokers, and flattens them into
        one set.

    -   The Identity Broker signs the token of claims.

    -   Note: a consumer of claims (e.g. a Claim Clearinghouse) accepting the
        “ga4gh” OIDC token claim signed by a given Identity Broker also accepts
        the chain of trust that such claims were collected correctly, are
        ligitimently derived from the sources of authority, and are presented
        accurately.

8.  <a name="requirement-8"></a> RI Claims are designed for machine
    interpretation only to make an access decision and is a non-goal to support
    rich user interface requirements nor do these claims fully encode the audit
    trail.

9.  <a name="requirement-9"></a> An identity can have several affiliations and
    the permissions can be coupled to one of them using the
    “[condition](#condition-optional-on-specific-ri-claims)” field.

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

## Claim Object Fields

Each [RI claim](#researcher-identity-claim-ri-claim) name maps to an array of
claim objects within a “ga4gh” root OIDC claim object (see
[example](#example-ri-claims)). Fields within the claim object are:

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

-   A condition on a claim object that indicates it is only valid if the
    contents of the condition are present elsewhere in the Passport.

-   Fields that are not specified in the condition are not required to match
    (i.e. any value will be accepted within that field).

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
    [RI claim](#researcher-identity-claim-ri-claim) and its corresponding
    [fields](#claim-object-fields) match as per the matching algorithms
    described elsewhere in this specification, along with the following
    requirements:

    -   A condition field matches when any one string within the specified list
        matches a corresponding claim’s field in the passport.

    -   All condition fields that are specified MUST match the same claim in the
        passport.

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

-   The Condition field MUST NOT be present within a claim object unless a
    [claim’s definition](#ga4gh-researcher-identity-claim-definitions)
    explicitly indicates it is optional.

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

3.  The URL SHOULD also be as short as reasonably possible while avoid
    collisions, and MUST NOT exceed 255 characters.

4.  The URL MUST NOT be followed by the algorithm making an access decision.

5.  URLs SHOULD resolve to a human readable document for a policy maker to
    reason about.

### Claim Expiry

In addition to any other policy restrictions that a Claim Clearinghouse may
enforce, Claim Clearinghouses that provide access for a given duration provided
by the user (excluding any revocation policies) MUST enforce one of the
following algorithm options to ensure that claim expiry is accounted for:

**Option A**: use the following algorithm to determine if the RI Claim is valid
for the entire duration of the requested duration:

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

## Encoding Use Cases

Use cases include, but are not limited to the following:

### Public Access

-   Public access data MAY wish to make use of RI Claims to encode information about
    who is making the data or access request in addition to the `sub` field within
    the passport itself.

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

    -   [ga4gh.ControlledAccessGrants](#ga4ghcontrolledaccessgrants) to encode
        permissions associated with specific data or datasets.
        
    -   [ga4gh.AffiliationAndRole](#ga4ghaffiliationandrole) to associate a user
        with a role within a specific organization. Additionally the
        ga4gh.ControlledAccessGrants MAY make use of the role and affiliation
        through a [condition](#condition-optional-on-specific-ri-claims) field.
        
    -   Any other RI claim that may be required to meet controlled access policies.

## Claim and Token Revocation

As per the
[GA4GH AAI Specification on Token Revocation](https://github.com/ga4gh/data-security/blob/master/AAI/AAIConnectProfile.md#token-revocation),
the following mechanisms are available within RI Claims:

1.  Claims have an [asserted](#asserted-required) field to allow downstream
    policies to limit the life, if needed, of how long assertions will be
    accepted for use with access and refresh tokens.

2.  Claims have an [expires](#expires-required) field to allow Claim
    Clearinghouses to limit the life of access and refresh tokens.

At a minimum, these RI Claim fields MUST be checked by all Claim Clearinghouses
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
|---------|------------|------------------------------------|---------------------------------------------------------------|
| 0.9.1   | 2019-07-08 | Craig Voisin                       | Clarify use cases, rephrase multi-value, update links         |
| 0.9.0   | 2017-      | Craig Voisin, Mikael Linden et al. | Initial working version                                       |

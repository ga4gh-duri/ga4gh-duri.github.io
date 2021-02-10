# Researcher Identities: GA4GH Passports and Visas

## Quick Links

- [GA4GH Passport Specification](http://bit.ly/ga4gh-passport-v1)
- [GA4GH Authentication and Authorization Infrastructure (AAI) OpenID Connect Profile](http://bit.ly/ga4gh-aai-profile)
- [Update Procedure](UPDATE_PROCEDURE.md) for Researcher IDs content 

## Introduction

Research groups around the world are making datasets available to other researchers through data sharing repositories such as EGA and dbGaP. However, access processes are fraught with difficulties and the following shortcomings have been identified:

- It is inconsistent: different Data Access Committees (DACs) may reach different conclusions regarding appropriate access.
- It is cumbersome:  DACs have a difficult time identifying who a bona fide researcher is, and have difficulty validating their identity.
- It is not scalable: the number of requests for access to human subjects data is growing at a supralinear rate, and it is growing increasingly difficult for DACs to keep up.

The genomics community was therefore in need of:

- a consistent definition of who a bona fide researcher is
- one or more identity providers that respect this definition and provide secure digital identities that researchers can use online to access various federated data repositories around the world
- a standard way to express data access rights that can be used to authorise researchers to compute on data in an increasingly automated manner

GA4GH Passport specification aims to support data access policies within current and evolving data access governance systems. This specification defines [Passports](http://bit.ly/ga4gh-passport-v1#passport) and [Passport Visas](http://bit.ly/ga4gh-passport-v1#passport-visa) as the standard way of communicating the data access authorizations that a user has based on either their role (e.g. researcher), affiliation, or access status. Passport Visas from trusted organizations can therefore express data access authorizations that require either a registration process (for the [Registered Access data access model](https://doi.org/10.1038/s41431-018-0219-y)) or custom data access approval (such as the Controlled Access applications used for many datasets).

Data access authorization information is encoded as Passports and transmitted according to [GA4GH AAI Specification](http://bit.ly/ga4gh-aai-profile). Passports are consumed to provide access to the user in a technical environment. For example, to support Registered Access, Passports allow for the encoding and identification of users with Bona Fide Researcher Registered Access status. To simplify access to multiple data sets, multiple Passport Visas that a user has acquired to authorize dataset access may be used simultaneously.

Organizations and individuals issuing and using Passport Visas must adhere to corresponding data access and data protection policies and regulations, with respect to both the data to which Passport Visas may be used to gain access, and to the personal data of the individual to which Passport Visas apply.

In addition to the further details below, there are two available recorded webinars to help get you started:
1) A high level overview of the GA4GH Passports concept and benefits
[![](http://img.youtube.com/vi/l5Cu76NQyUY/0.jpg)](http://www.youtube.com/watch?v=l5Cu76NQyUY "")

2) An in depth technical deep dive into the specification  
[![](http://img.youtube.com/vi/K7HID5KAhz0/0.jpg)](http://www.youtube.com/watch?v=K7HID5KAhz0 "")

### Example scientific use case of GA4GH Passport implementation: biobank data discovery using ELIXIR and Beacon

Biobank collections across the globe need a secure way to make data
created from their samples discoverable. Beacon service supports this
process, and makes simple searching like finding an existence (YES/NO) of a
genomic variant publicly possible. However, after discovering datasets the
next thing a user typically wants is to make a more detailed query. How
many individuals have been detected in total with the variant in question? Can
I derive allele frequency information across global genome data collections? 
Is it possible to gain access to the original datasets where the anonymised
statistical data has been calculated?

These questions mean that user needs to have a deeper data access "tier" to
the datasets underlying the search. The data access committees responsible
for each of the datasets need to consider that the users asking for deeper
access are who they claim to be, which organisation they are affiliated to,
and evaluate the purpose why data access is being requested before giving
access.

GA4GH Passports have two major technical use cases, Registered Access and
Controlled Access, which both can be applied to the biobank data discovery
use case. Passport-based implementation of Registered Access in the ELIXIR
research infrastructure and Beacon services is activated when a deeper data
access is requested.

The user first authenticates using their unique ELIXIR ID. Authentication
information is passed from the user's home organisation identity provider
service to the Beacon service using a trust framework of an identity federation 
and ELIXIR's infrastructure services. No usernames & password information 
are being passed, but Beacon receives a standard signal from ELIXIR that 
the user is authenticated to a certain level of assurance.

Identity federations provide limited information about a user to the relying
services (i.e. Beacon). Information about the user can at this 
point be enriched with a Passport including their status and role as the researcher. 
Passports could be requested and sent to the Beacon service relying on ELIXIR, for
instance if they are needed to evaluate deeper data access rights. An established
status and affiliation as a researcher could alone allow deeper searching of the
underlying data, depending on the data access policies guarding the terms why
data was originally created.

This is an example use case for Registered access. Controlled access
to data typically requires an active interaction with a Data Access Committee
(DAC) body. In the case of Controlled Access, rights given to an authenticated
user are stored and may then be retrieved by a trusted service such as ELIXIR
in the Passport format from the Passport specification. After a user with a
Passport has been authenticated and agrees to release such Passport Visas to the
relying service, the Passport Visas can then be released to the relying service that
has established a trusted relationship with ELIXIR and the DAC.

Foreseen impact:

GA4GH Passport specification establishes a standard way how identity and
access information can be communicated in a machine-readable way between
services and decision makers to serve users with a more streamlined 
data access process in collaboration with the data access committees 
and data hosting services.

## Specification Overview

The [GA4GH Passport specification](http://bit.ly/ga4gh-passport-v1) defines a technical standard specifying a machine readable data format to attribute credentials to a person to validate their identity and verify that they are permitted to access data held by a third-party data custodian. The Passport specification further defines the mechanism by which such credentials are exchanged in a secure manner. By adopting the Passport specification, a data custodian should have the ability to greatly speed-up the sharing of data with trusted persons such as researchers working on next generations health studies.

Credentials for data access are assigned to a person in the form of Passport Visas. A number of Passport Visas can be assigned to a person, thereby constituting a Passport for that person. Passport Assertion Sources, such as research institutions, can create assertions to associate with a person's identity that can turn into Passport Visas.

Claims may include:

1. The affiliation and role of the person (AffiliationAndRole)
2. The accepted terms and policies by the person (AcceptedTermsAndPolicies)
3. The status of the person with respect to access (ResearcherStatus)
4. A list of datasets to which this person has been granted access (ControlledAccessGrants).
5. An association for the user between multiple identities for the purpose of applying
   Passport Visas assigned to different account to the same access request (LinkedIdentities).

Claims can be set to expire and also contain additional information such as a URL link to a web resource further detailing the content of the claim in a human readable fashion.

Upon creation of Passport Visas, a Passport Broker will sign, store and/or transfer the Passport Visas as part of a standard OpenID Connect (OIDC) token to downstream services that can use it to authorize access to data.

## Flow Of Claims

![Basic Passport Flow of Data](/assets/img/passport_flow_of_data_basic.svg)

See the [Overview](http://bit.ly/ga4gh-passport-v1#overview) section of the Passport specification for an understanding of the services involved. Note that it is possible for some implementations can combine services from the diagram into one larger service, and in such cases it must comply to requirements of all the services that it implements.

## How Claims Work

The precise method to create Passport Visas, inject them into Passports, and use them downstream will vary from system to system. This flexibility speaks to the many use cases and different types of systems that are deployed and want to federate claims.

Here is an example of the life of a claim:

1. An organization that creates access assertions ([Passport Assertion Source](http://bit.ly/ga4gh-passport-v1#passport-assertion-source)) creates a new assertion in a system that stores claim metadata into a database ([Passport Assertion Repository](http://bit.ly/ga4gh-passport-v1#passport-assertion-repository). The person acting on behalf of the Passport Assertion Source organization could be a specialized user who has knowledge of the researcher they are making a assertion on behalf of, or it could be a researcher making a assertion about themselves. Another alternative is that a system can collect metadata about a user from another system and make the assertion on the researcher's behalf.
    1. The assertion information is stored in a Passport Assertion Repository.
    2. Audit information is added about who made the assertion, when the assertion was made, and any other artifacts it may have about around making the assertion.
    3. The Passport Assertion Source may choose to have the assertion expire in 30 days, and can reissue a replacement assertion if needed again after that. 
2. A researcher, using an application, logs into a system (Passport Broker) that knows how to connect to a Passport Visa Issuer service that can read the assert and package it into a Passport Visa. then securely sign this visa.
    1. The login token request contains an OIDC scope of "ga4gh_passport_v1" to indicate that it wishes to have a Passport accessible by presenting the access token.
    2. The Passport Broker asks the user which Passport Visas the researcher wishes to release to the downstream system (Passport Clearinghouse) that wants to use the Passport.
    3. The Passport Broker packages up all the Passport Visas the researcher wishes to release and mints an OIDC access token, and signs the token with the Passport Broker's private key. This signature will be used by downstream systems to verify the authenticity of the Passport and maintain its integrity (i.e. prevents any party from tampering with the contents).
3. The researcher's application either is using a Passport Clearinghouse directly or passes the access token along to a Passport Clearinghouse when it attempts to get access to data.
    1. The Passport Clearinghouse looks at the issuer of the Passport and determines if it trusts the issuer based on a whitelist. If not trusted, the request is denied.
    2. The Passport Clearinghouse fetches the Passport Broker's public key and verifies the signature of the Passport. Other access token checks are performed, such as checking the token's overall expiry timestamp ("exp" claim). Any problem with the token results in a request denied.
    3. The Passport Clearinghouse makes a /userinfo call back to the Passport Broker to fetch the Passport in the form of a JWT Claim.
    4. Passport Visas within the Passport are compared to access policies that have been configured for the data being requested and the access level being requested.
        1. Registered access using a Beacon may require the Registered Access claims to be present.
        2. Access to some datasets may require a specific ControlledAccessGrants claim to be present.
    5. The Passport Clearinghouse will accept or reject claims and tries to find a set of acceptable claims that match the access policy.  
        1. The "[exp](http://bit.ly/ga4gh-ri-v1#exp)" JWT claim is checked to make sure it hasn't expired, and may use [special expiry checking logic](http://bit.ly/ga4gh-ri-v1#passport-visa-expiry) to make sure it isn't going to expire soon.
        2. The "[type](http://bit.ly/ga4gh-ri-v1#type)" field is checked to see if it matches the Passport Visa Type required for the policy in question.
        3. The "[source](http://bit.ly/ga4gh-ri-v1#source)" field is checked to see if it is from a trusted source from a trusted source whitelist.
        4. The "[value](http://bit.ly/ga4gh-ri-v1#value)" field is checked to see if it meets the requirements of the access policy.
        5. The "[asserted](http://bit.ly/ga4gh-ri-v1#asserted)" and "[by](http://bit.ly/ga4gh-ri-v1#by)" fields may be checked as well, depending on the policy.
        6. The "[conditions](http://bit.ly/ga4gh-ri-v1#conditions)" field is also checked to see if the validity of this Passport Visa has a dependency on having another Passport Visa also present in the same Passport.
4. If the Passport Clearinghouse decides that the Passport meets the access policy for the data in question, the service proceeds to authorize the researcher's use of the data.
    1. Some Passport Clearinghouses will authorize use of the data by changing the researcher's permissions and issuing a cloud-specific access token to read the bytes using their own cloud-native tools and services.
    2. Other Passport Clearinghouses will read the bytes from another service using special access token that it holds which contains permission to do so, then return the bytes back to the researcher.
    3. Yet other varieties of Passport Clearinghouses will just proceed taking an action internally or reading bytes directly from a database in and of itself without much need for downstream access tokens.
5. Some systems will use the Passport once, exchange it for a downstream access token, and not use the Passport again. Other systems will use the Passport multiple times until the passport token expires.
    1. Some systems can check the validity of a set of Passport Visas every hour and revoke or update access expiry accordingly.
    2. Other systems do not issue refresh tokens, and the only option to get a new Passport is to have the user do a fresh login (OIDC Authorization Flow) to fetch a new Passport.

## Authorization using Standard Passport Visas

[Standard Passport Visa Type Definitions](http://bit.ly/ga4gh-passport-v1##ga4gh-standard-passport-visa-type-definitions)
may be used as a means to transfer permissions from one system to another in
a system agnostic manner.

#### AffiliationAndRole

For the purposes of authorization, this Passport Visa Type can be thought of
as asserting membership in a group. For example, "the user represented by this
Passport Visa Type should have access to resources intended for general use by
members of this role and affiliation".

Example Passport Visa payload:

```
{
  "iss": "https://login.elixir-czech.org/oidc",
  "sub": 1234,
  "iat": 150000000,
  "exp": 150010000,
  "ga4gh_visa_v1" : {
    "type": "AffiliationAndRole",
    "value": "faculty@med.stanford.edu",
    "source": "https://grid.ac/institutes/grid.240952.8",
    "by": "so"
  }
}
```

A Passport Clearinghouse may use a Passport Visa payload like the example above
to grant read access to a particular dataset for a wide set of faculty
collaborators from Stanford Medicine.

Alternatively, a ControlledAccessGrants Passport Visa could add the
"[conditions](http://bit.ly/ga4gh-passport-v1#conditions)" field that requires that
the user retains their status as a group member of "faculty at Stanford
Medicine" for the DAC access grant to the data to remain valid.

#### AcceptedTermsAndPolicies

Some datasets require that a user or organization acknowledges various terms,
policies, and conditions or meet particular criteria in order to access the
dataset. For example, a dataset may require that a user has provided all of the
following:

-   **Agree to ethical handling of the data**: a Passport Visa assertion may be 
    added once the user reads the policy and clicks that he/she agrees to uphold 
    its contents.

-   **Agree that an online ethics training course has been completed**: a
    Passport Visa assertion may be added once the user agrees he/she has
    completed online ethics training. 

For the above examples, the Passport Visa payloads may look something like this
(shown as unpacked payloads without headers or signatures to make it more
reader-friendly):

```
"ga4gh_passport_v1": [
    { // shown as unpacked from JWS
      "iss": "https://login.elixir-czech.org/oidc",
      "sub": 1234,
      "iat": 1560000000,
      "exp": 1560010000,
      "ga4gh_visa_v1" : {
        "type": "AcceptedTermsAndPolicies",
        "value": "https://claims.example.org/training/101",
        "source": "<https://grid.ac/institutes/grid.5335.0>",
        "by": "self"
      }
    },
    { // shown as unpacked from JWS
      "iss": "https://login.elixir-czech.org/oidc",
      "sub": 1234,
      "iat": 1560000300,
      "exp": 1575552300,  // 6 months after "iat"
      "ga4gh_visa_v1" : {
        "type": "AcceptedTermsAndPolicies",
        "value": "https://claims.example.org/tested/101",
        "source": "<https://grid.ac/institutes/grid.5335.0>",
        "by": "self"
      }
    },
    { // shown as unpacked from JWS
      "iss": "https://login.elixir-czech.org/oidc",
      "sub": 1234,
      "iat": 1560000400,
      "exp": 1560010400,
      "ga4gh_visa_v1" : {
        "type": "AcceptedTermsAndPolicies",
        "value": "https://claims.example.org/ethics/101",
        "source": "<https://grid.ac/institutes/grid.5335.0>",
        "by": "self"
      }
    }
  ]
}
```

A Passport Clearinghouse would look for all three entries to be present on the
same Passport and to be valid all within the window of access being requested by
the researcher.

#### ResearcherStatus

For the purposes of authorization, this Passport Visa Type encodes what general
researcher groups the user is a member of. For example, perhaps the user has
been awarded a Clinical Research Associate certification such as this Passport
Visa payload:

```
{
  "iss": "https://login.example.org/oidc",
  "sub": 1234,
  "iat": 150000000,
  "exp": 150010000,
  "ga4gh_visa_v1" : {
    "type": "ResearcherStatus",
    "value": "<https://acrpnet.org/certifications/cra-certification>",
    "source": "<https://grid.ac/institutes/grid.470375.2>",
    "by": "system"
  }
}
```

Another example is that the user may be awarded a certificate that he or she has
completed ethics training.

-   **Receive training**: a Passport Visa assertion may be added at the end of
    the video after the user clicks that they have understood the content.

-   **Score at least 95% on a competency test on the training material**: a
    Passport Visa assertion may be added after meeting this threshold on the
    test, and expires every 6 months.

#### ControlledAccessGrants

This Passport Visa Type encodes the any grants for controlled access datasets.
Controlled Access indicates that the data should not be read unless an appropriate
source of authority has authorized this access explicitly. This is in contrast to
Public Access as well as Registered Access, for example.

It is common that a Passport Clearinghouse will only accept ControlledAccessGrants
Passport Visas if they come from a trusted issuer, the source is a trusted
organization that has the authority, and the "by" field is set to "dac" to indicate
that the organization's Data Access Committee has approved this access. Alternative
requirements may be used instead, however only grants for Controlled Access
datasets are intended to be encoded within this Passport Visa Type.

An example Passport Visa payload:

```
{
  "iss": "https://dbgap.nih.gov/oidc",
  "sub": 1234,
  "iat": 150000000,
  "exp": 150010000,
  "ga4gh_visa_v1" : {
    "type": "ControlledAccessGrants",
    "value": "https://claims.example.org/datasets/33333",
    "source": "<https://grid.ac/institutes/grid.48336.3a>",
    "by": "dac"
  }
}
```

In the example above, the user has been granted access to dataset 33333 by the
National Cancer Institute's DAC which is using dbGaP to present the claim as the
[Broker](http://bit.ly/ga4gh-aai-profile#term-broker).

It is important to note that the token issuer ("iss") may not be the same
organization represented by the "source" field, as shown in the example above.

#### LinkedIdentities

This Passport Visa Type provides a means for an Broker to associate two
different accounts
("[Passport Visa Identities](http://bit.ly/ga4gh-passport-v1#passport-visa-identity)")
with one user. Some Brokers have the ability to link accounts together, and in
doing so the Broker can combine Passport Visas from these accounts into one
Passport. Brokers that provide account linking should follow security and privacy
best practices in their implementation of this feature.

If a Passport Clearinghouse wants to evaluate two Passport Visas when making an
authorization decision, and if those two Passport Visas come from different
accounts, then how does the Passport Clearinghouse know whether or not to trust
that these accounts were combined correctly given that Passports can be combined
at multiple levels of Brokers before arriving at the Passport Clearinghouse?
Which Broker combined these accounts, and can it be trusted?

To address these trust concerns, the LinkedIdentities claim can be provided by
Brokers. The claim contains two or more accounts that represent the same user and
is signed by the Broker. Using this Passport Visa Type, a Passport Clearinghouse
can know which Broker combined these accounts (within a chain of Brokers that may
have assembled the Passport), and can decide whether or not to trust that Broker
to do so correctly.

The use of this Passport Visa Type can prevent particular security issue where
Brokers that illegitimately combine claims from otherwise trusted sources will
fail to get access to resources when presenting them to a Passport Clearinghouse.

Example Passport Visa payload for LinkedIdentities:

```
{
  "iss": "https://broker.example3.org/oidc",
  "sub": "999999",
  "iat": 1549680000,
  "exp": 1581208000,
  ...
  "ga4gh_visa_v1": {
    "type": "LinkedIdentities",
    "value": "10001|https://issuer.example1.org/oidc,abcd|https://other.example2.org/oidc",
    "source": "https://broker.example3.org/oidc",
    "by": "system"
  }
}
```

In this example, a Broker (example3.org) has linked two other accounts for the
same user from example1.org (subject "10001") and example2.org (subject "abcd").
It did so using an automated system (`by = "system"`) of allowing the user to
present credentials for all three accounts as proof of identity ownership.

Notice that subjects "999999", "10001", and "abcd" are abstract account
identifiers and not email addresses or other personal information. These are
the same identifiers that can be found in other Passport Visas such that the
Passport Clearinghouse, when inspecting multiple Passport Visas as part of an
access policy, would verify that either:

1.  All the accounts are the same across the subset of Passport Visas of interest
    to the policy; or

2.  There exists a set of LinkedIdentities Passport Visas from trusted parties
    that allows the accounts associated Passport Visas of interest to be combined.

#### Claims Use for Registered Access

[Registered Access Encoding](http://bit.ly/ga4gh-passport-v1#registered-access) makes
use of two Passport Visas, and may need more Passport Visas if those requirements
come from different identities that are being combined ("Passport Visa
Identities"). This allows the assertions that show that the Registered Access
requirements have been met to come from different sources and for different roles.

For example (shown as unpacked payloads without headers or signatures to make it
more reader-friendly):

```
"ga4gh_passport_v1": [
    { // shown as unpacked payload from JWS
      "iss": "https://login.elixir-czech.org/oidc",
      "sub": 1234,
      "iat": 150000000,
      "exp": 150010000,
      "ga4gh_visa_v1" : {
        "type": "ResearcherStatus",
        "value": "<https://doi.org/10.1038/s41431-018-0219-y>",
        "source": "<https://grid.ac/institutes/grid.5335.0>",
        "by": "peer"
      }
    },
    { // shown as unpacked payload from JWS
      "iss": "auth.uni-heidelberg.de/oidc",
      "sub": 123123,
      "iat": 150001000,
      "exp": 150020000,
      "ga4gh_visa_v1" : {
        "type": "AcceptedTermsAndPolicies",
        "value": "<https://doi.org/10.1038/s41431-018-0219-y>",
        "source": "<https://grid.ac/institutes/grid.5253.1>",
        "by": "self"
      }
    },
    { // shown as unpacked payload from JWS
      "iss": "https://login.elixir-czech.org/oidc",
      "sub": "1234",
      "iat": 150000000,
      "exp": 150010000,
      ...
      "ga4gh_visa_v1": {
        "type": "LinkedIdentities",
        "value": "123123|auth.uni-heidelberg.de/oidc",
        "source": "https://broker.example3.org/oidc",
        "by": "system"
      }
    }
  ]
}
```

In the above example, the Registered Access Bona Fide Status came from a peer at
Cambridge University (grid.5335.0) and collected via ELIXIR whereas the
Registered Access Acceptance of Ethics came from Heidelberg University
(grid.5253.1) and was self-declared (i.e. the researcher herself made the
assertion) and is bound by her home organization, Heidelberg University.

The ResearcherStatus and AcceptedTermsAndPolicies Passport Visas come from two
different accounts ("Passport Visa Identities") as indicated by their "iss" and
"sub" JWT claims. These two claims can be treated as coming from the same user if
the Passport Clearinghouse trusts ELIXIR to combine them via the LinkedIdentities
Passport Visa included in the above example.

It is only when the two requirements of Registered Access are met, together on
one Passport from trusted sources, that Registered Access may apply to the
researcher in question. In this case, a Passport Clearinghouse that would
accept these Passport Visas must trust the Brokers of ELIXIR and Heidelberg
University as well as both [Claim Source
organizations](http://bit.ly/ga4gh-aai-profile#term-claim-source) encoded in the
"[source](http://bit.ly/ga4gh-passport-v1#source)" field (i.e. both Cambridge University
and Heidelberg University). The "[by](http://bit.ly/ga4gh-passport-v1#by)" field must
also be acceptable based on policies for the Passport Clearinghouse in addition to
other validation of the tokens and fields as described in the [AAI
specification](http://bit.ly/ga4gh-aai-profile) and the [Passport
specification](http://bit.ly/ga4gh-passport-v1).

## Why so many expiry timestamps?

Access tokens have an "exp" standard claim to represent when the token expires. The Passport in an access token and has an "exp" claim to indicate when it expires. This is separate from the expiry time of Passport Visas themselves, which each have an "exp" claim for when that Passport Visa expires. These different types of expiry timestamps serve different purposes:

- The Passport "exp" timestamp is the overall Passport token's lifetime. Passport Clearinghouses should reject such tokens outright and not look at any other contents once a token has expired.
- The Passport Visa "exp" timestamp allows each claim to represent when the Passport Assertion Source needs a Passport Clearinghouse to no longer permit access.

There are several advantages of this approach:

- Passport issuers can issue tokens that are short lived to reduce damage of leaked or stolen tokens, yet carry the intent of Passport Assertion Source organization to allow access for longer periods of time. This is especially important when checking Passport Visa validity over time is not feasible.
- Passport Visas can be cached by intermediary Passport Brokers and understand the Passport Assertion Source's intent for how long they can be cached before they expire. This can reduce the number of login flows the user needs to go through to collect claims from multiple, federated sources.
- Implementations can encode Passport Visas using standard libraries that do not need to understand how to sort out the difference between the expiry of individual visas and how that relates to the expiry of the Passport tokens.
- The understanding of the duration needed before expiry can be done on a visa by visa basis by the Passport Clearinghouse alone. The upstream Passport Brokers do not need to understand the various access scenarios to know how to limit expiry when they do not fully understand the use cases and requirements.

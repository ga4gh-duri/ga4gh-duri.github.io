# Researcher Identity & Access Claims

## Quick Links

- [GA4GH Researcher Identity & Access Claims (RI Claims) Specification](http://bit.ly/ga4gh-ri-v1)
- [GA4GH Authentication and Authorization Infrastructure (AAI) OpenID Connect Profile](http://bit.ly/ga4gh-aai)
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

GA4GH Researcher Identity & Access Claims (aka RI Claims) specification aims to support data access policies within current and evolving data access governance systems. RI Claims defines [Passports](http://bit.ly/ga4gh-ri-v1#passport) and [Passport Visas](http://bit.ly/ga4gh-ri-v1#passport-visa) as the standard way of communicating the data access authorizations that a user has based on either their role (e.g. researcher), affiliation, or access status. Passport Visas from trusted organizations can therefore express data access authorizations that require either a registration process (for the [Registered Access data access model](https://doi.org/10.1038/s41431-018-0219-y)) or custom data access approval (such as the Controlled Access applications used for many datasets).

Data access authorization information is encoded as Passports and transmitted according to [GA4GH AAI Specification](http://bit.ly/ga4gh-aai-profile). Passports are consumed to provide access to the user in a technical environment. For example, to support Registered Access, Passports allow for the encoding and identification of users with Bona Fide Researcher Registered Access status. To simplify access to multiple data sets, multiple Passport Visas that a user has acquired to authorize dataset access may be used simultaneously.

Organizations and individuals issuing and using Passport Visas must adhere to corresponding data access and data protection policies and regulations, with respect to both the data to which Passport Visas may be used to gain access, and to the personal data of the individual to which Passport Visas apply.

### Example scientific use case of GA4GH RI Claims implementation: biobank data discovery using ELIXIR and Beacon

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
in the Passport format from the RI Claims specification. After a user with RI
claims has been authenticated and agrees to release such claims to the relying
service, the claims can then be released to the relying service that has
established a trusted relationship with ELIXIR and the DAC.

Foreseen impact:

GA4GH RI Claims standard establishes a standard way how identity and
access information can be communicated in a machine-readable way between
services and decision makers to serve users with a more streamlined 
data access process in collaboration with the data access committees 
and data hosting services.

## Specification Overview

The [GA4GH Researcher Identity & Access Claims (RI Claims) specification](http://bit.ly/ga4gh-ri-v1) defines a technical standard specifying a machine readable data format to attribute credentials to a person to validate their identity and verify that they are permitted to access data held by a third-party data custodian. The RI Claims specification further defines the mechanism by which such credentials are assigned and exchanged in a secure manner. By adopting the RI Claims specification a data custodian should have the ability to greatly speed-up the sharing of data with trusted persons such as researchers working on next generations health studies.

Credentials for data access are assigned to a person in the form of Passport Visas. A number of Passport Visas can be assigned to a person and included in a signed access token, thereby constituting a Passport for that person. Passport Assertion Sources, such as research institutions, can create assertions to associate with a person's identity that can turn into Passport Visas.

Claims may include:

1. The affiliation and role of the person (AffiliationAndRole)
2. The accepted terms and policies by the person (AcceptedTermsAndPolicies)
3. The status of the person with respect to access (ResearcherStatus)
4. A list of datasets to which this person has been granted access (ControlledAccessGrants).
5. An association for the user between multiple identities for the purpose of applying
   Passport Visas assigned to different account to the same access request (LinkedIdentities).

Claims can be set to expire and also contain additional information such as a URL link to a web resource further detailing the content of the claim in a human readable fashion.

Upon creation of Passport Visas, a Passport Broker will sign, store and/or transfer the Passport Visas as part of a standard OpenID Connect (OIDC) token to downstream services that can use it to authorize access to data.

## How Claims Work

The precise method to create Passport Visas, inject them into Passports, and use them downstream will vary from system to system. This flexibility speaks to the many use cases and different types of systems that are deployed and want to federate claims.

Here is an example of the life of a claim:

1. An organization that creates access assertions ([Passport Assertion Source](http://bit.ly/ga4gh-ri-v1#passport-assertion-source)) creates a new assertion in a system that stores claim metadata into a database ([Passport Assertion Repository](http://bit.ly/ga4gh-ri-v1#passport-assertion-repository). The person acting on behalf of the Passport Assertion Source organization could be a specialized user who has knowledge of the researcher they are making a assertion on behalf of, or it could be a researcher making a assertion about themselves. Another alternative is that a system can collect metadata about a user from another system and make the assertion on the researcher's behalf.
    1. The assertion information is stored in a Passport Assertion Repository.
    2. Audit information is added about who made the assertion, when the assertion was made, and any other artifacts it may have about around making the assertion.
    3. The Passport Assertion Source may choose to have the assertion expire in 30 days, and can reissue a replacement assertion if needed again after that. 
2. A researcher, using an application, logs into a system (Passport Broker) that knows how to connect to a Passport Visa Signatory service that can read the assert and package it into a Passport Visa. then securely sign this visa.
    1. The login token request contains an OIDC scope of "ga4gh_passport_v1" to indicate that it wishes to have a Passport accessible by presenting the access token.
    2. The Passport Broker asks the user which Passport Visas the researcher wishes to release to the downstream system (Passport Clearinghouse) that wants to use the Passport.
    3. The Passport Broker packages up all the Passport Visas the researcher wishes to release and mints an OIDC access token, and signs the token with the Identity Broker's private key. This signature will be used by downstream systems to verify the authenticity of the Passport and maintain its integrity (i.e. prevents any party from tampering with the contents).
3. The researcher's application either is using a Passport Clearinghouse directly or passes the access token along to a Passport Clearinghouse when it attempts to get access to data.
    1. The Passport Clearinghouse looks at the issuer of the Passport and determines if it trusts the issuer based on a whitelist. If not trusted, the request is denied.
    2. The Passport Clearinghouse fetches the Passport Broker's public key and verifies the signature of the Passport. Other access token checks are performed, such as checking the token's overall expiry timestamp ("exp" claim). Any problem with the token results in a request denied.
    3. The Passport Clearinghouse makes a /userinfo call back to the Passport Broker to fetch the Passport in the form of a JWT Claim.
    4. Passport Visas within the Passport are compared to access policies that have been configured for the data being requested and the access level being requested.
        1. Protected access using a Beacon may require the Registered Access claims to be present.
        2. Access to some datasets may require a specific ControlledAccessGrants claim to be present.
    5. The Passport Clearinghouse will accept or reject claims and tries to find a set of acceptable claims that match the access policy.  
        1. The "[exp](http://bit.ly/ga4gh-ri-v1#exp)" JWT claim is checked to make sure it hasn't expired, and may use [special expiry checking logic](http://bit.ly/ga4gh-ri-v1#passport-visa-expiry) to make sure it isn't going to expire soon.
        2. The "[type](http://bit.ly/ga4gh-ri-v1#type)" field is checked to see if matches the Passport Visa Type required for the policy in question.
        3. The "[source](http://bit.ly/ga4gh-ri-v1#source)" field is checked to see if it is from a trusted source from a trusted source whitelist.
        4. The "[value](http://bit.ly/ga4gh-ri-v1#value)" field is checked to see if it meets the requirements of the access policy.
        5. The "[asserted](http://bit.ly/ga4gh-ri-v1#asserted)" and "[by](http://bit.ly/ga4gh-ri-v1#by)" fields may be checked as well, depending on the policy.
        6. The "[conditions]((http://bit.ly/ga4gh-ri-v1#conditions)" field is also checked to see if the validity of this Passport Visa has a dependency on having another Passport Visa also present in the same Passport.
4. If the Passport Clearinghouse decides that the Passport meets the access policy for the data in question, the service proceeds to authorize the researcher's use of the data.
    1. Some Passport Clearinghouses will authorize use of the data by changing the researcher's permissions and issuing a cloud-specific access token to read the bytes using their own cloud-native tools and services.
    2. Other Passport Clearinghouses will read the bytes from another service using special access token that it holds which contains permission to do so, then return the bytes back to the researcher.
    3. Yet other varieties of Passport Clearinghouses will just proceed taking an action internally or reading bytes directly from a database in and of itself without much need for downstream access tokens.
5. Some systems will use the Passport once, exchange it for a downstream access token, and not use the Passport again. Other systems will use the Passport multiple times until the passport token expires.
    1. Some systems can check the validity of a set of Passport Visas every hour and revoke or update access expiry accordingly.
    2. Other systems do not issue refresh tokens, and the only option to get a new Passport is to have the user do a fresh login (OIDC Authorization Flow) to fetch a new Passport.

## Flow Of Claims

![alt text](/assets/img/flow_of_claims.png)

## Why so many expiry timestamps?

Access tokens have an "exp" standard claim to represent when the token expires. The Passport in an access token and has an "exp" claim to indicate when it expires. This is separate from the expiry time of Passport Visas themselves, which each have an "exp" claim for when that Passport Visa expires. These different types of expiry timestamps serve different purposes:

- The Passport "exp" timestamp is the overall Passport token's lifetime. Passport Clearinghouses should reject such tokens outright and not look at any other contents once a token has expired.
- The Passport Visa "exp" timestamp allows each claim to represent when the Passport Assertion Source needs a Passport Clearinghouse to no longer permit access.

There are several advantages of this approach:

- Passport issuers can issue tokens that are short lived to reduce damage of leaked or stolen tokens, yet carry the intent of Passport Assertion Source organization to allow access for longer periods of time. This is especially important when checking Passport Visa validity over time is not feasible.
- Passport Visas can be cached by intermediary Passport Brokers and understand the Passport Assertion Source's intent for how long they can be cached before they expire. This can reduce the number of login flows the user needs to go through to collect claims from multiple, federated sources.
- Implementations can encode Passport Visas using standard libraries that do not need to understand how to sort out the difference between the expiry of individual visas and how that relates to the expiry of the Passport tokens.
- The understanding of the duration needed before expiry can be done on a visa by visa basis by the Passport Clearinghouse alone. The upstream Passport Brokers do not need to understand the various access scenarios to know how to limit expiry when they do not fully understand the use cases and requirements.

# Researcher Identity & Access Claims

## Quick Links

- [GA4GH Researcher Identity & Access Claims Specification](http://bit.ly/ri-claims)
- [GA4GH Authentication and Authorization Infrastructure (AAI) OpenID Connect Profile](http://bit.ly/g4gh-aai)

## Introduction

Research groups around the world are making datasets available to other researchers through data sharing repositories such as EGA and dbGaP. However, access processes are fraught with difficulties and the following shortcomings have been identified:

- It is inconsistent: different Data Access Committees (DACs) may reach different conclusions regarding appropriate access.
- It is cumbersome:  DACs have a difficult time identifying who a bona fide researcher is, and have difficulty validating their identity.
- It is not scalable: the number of requests for access to human subjects data is growing at a supralinear rate, and it is growing increasingly difficult for DACs to keep up.

The genomics community was therefore in need of:

- a consistent definition of who a bona fide researcher is
- one or more identity providers that respect this definition and provide identities in the virtual world that travel with the researcher across various data sharing repositories

The GA4GH Researcher Identity & Access Claims (aka RI Claims) specification aims to support access policies that rely on either a researcher's role, affiliation, or access status, which may all form part of the researcher's claims "passport". To support the Registered Access data access model, RI Claims allows for the encoding and recognition of researchers with Bona Fide Researcher Registered Access status.

## Specification Overview

The [GA4GH Researcher Identity & Access Claims (RI Claims) specification](http://bit.ly/ri-claims) defines a technical standard specifying a machine readable data format to attribute credentials to a person to validate their identity and verify that they are permitted to access data held by a third-party data custodian. The RI Claims specification further defines the mechanism by which such credentials are assigned and exchanged in a secure manner. By adopting the RI Claims specification a data custodian should have the ability to greatly speed-up the sharing of data with trusted persons such as researchers working on next generations health studies.

Credentials for data access are assigned to a person in the form of Claims. A number of Claims can be assigned to a person and included in a signed access token, thereby constituting a Passport for that person. Claim Authorities, such as research institutions, can create Claims associate with a person's identity.

Claims may include:

1. The affiliation and role of the person (AffiliationAndRole)
2. The accepted terms and policies by the person (AcceptedTermsAndPolicies)
3. The status of the person with respect to access (ResearcherStatus)
4. A list of datasets to which this person has been granted access (ControlledAccessGrants).

Claims can be set to expire and also contain additional information such as a URL link to a web resource further detailing the content of the claim in a human readable fashion. To learn more please refer to the

Upon creation of the Claims, an Identity Broker will sign the Claims and store or transfer the Claims as part of a standard OpenID Connect (OIDC) token to downstream services that can use it to authorize access to data.

## How Claims Work

The precise method to create claims, inject them into passports, and use them downstream will vary from system to system. This flexibility speaks to the many use cases and different types of systems that are deployed and want to federate claims.

Here is an example of the life of a claim:

1. A source of authority ([Claim Authority](https://docs.google.com/document/d/11Wg-uL75ypU5eNu2p_xh9gspmbGtmLzmdq5VfPHBirE/edit#heading=h.h79hhcau08w5)) creates a new claim in a system that stores claim metadata into a database. The Claim Authority could be a specialized user who has knowledge of the researcher they are making a claim on behalf of, or it could be a researcher making a claim about themselves. Another alternative is that a system can collect metadata about a user from another system and make the claim on the researcher's behalf.
    1. The claim information is stored in a database.
    2. Audit information is added about who asserted the claim, when the claim was made, and any other artifacts it may have about around making the claim.
    3. The Claim Authority may choose to have the claim expire in 30 days, and can reissue a replacement claim if needed again after that. 
2. A researcher, using an application, logs into a system (Identity Broker) that knows how to access the claim and package it into a Passport.
    1. The login token request contains an OIDC scope of "ga4gh" to indicate that it wishes to have Identity Claims attached to the access token.
    2. The Identity Broker asks the user which claims the researcher wishes to release to the downstream system (Claim Clearinghouse) that wants to use the Passport.
    3. The Identity Broker packages up all the claims the researcher wishes to release and puts them into an OIDC access token, and signs the token with the Identity Broker's private key. This signature will be used by downstream systems to verify the authenticity of the Passport and maintain its integrity (i.e. prevents any party from tampering with the contents).
3. The application either is a Claim Clearinghouse or passes the Passport access token along to a Claim Clearinghouse when it attempts to get access to data.
    1. The Claim Clearinghouse looks at the issuer of the Passport and determines if it trusts the issuer based on a whitelist. If not trusted, the request is denied.
    2. The Claim Clearinghouse fetches the Identity Broker's public key and verifies the signature of the Passport. Other OIDC token checks are performed, such as checking the token's overall expiry timestamp ("exp" claim). Any problem with the token results in a request denied.
    3. Claims are compared to access policies that have been configured for the data being requested and the access level being requested.
        1. Protected access using a Beacon may require the Registered Access claims to be present.
        2. Access to some datasets may require a specific ControlledAccessGrants claim to be present.
    4. The claims are extracted from the Passport and the contents of the claims are compared to the required claims for the access policy. The Claim Clearinghouse will accept or reject claims and tries to find a set of acceptable claims that match the access policy.  
        1. The "[expires](https://docs.google.com/document/d/11Wg-uL75ypU5eNu2p_xh9gspmbGtmLzmdq5VfPHBirE/edit#heading=h.tdge5487ert9)" field is checked to make sure it hasn't expired, and may use [special expiry checking logic](https://docs.google.com/document/d/11Wg-uL75ypU5eNu2p_xh9gspmbGtmLzmdq5VfPHBirE/edit#heading=h.ruipgcz7pe27) to make sure it isn't going to expire soon.
        2. The "[source](https://docs.google.com/document/d/11Wg-uL75ypU5eNu2p_xh9gspmbGtmLzmdq5VfPHBirE/edit#heading=h.7gkkcdjjulcj)" field is checked to see if it is from a trusted source from a trusted source whitelist.
        3. The "[value](https://docs.google.com/document/d/11Wg-uL75ypU5eNu2p_xh9gspmbGtmLzmdq5VfPHBirE/edit#heading=h.vddhgptnqj4f)" field is checked to see if it meets the requirements of the access policy.
        4. The "[asserted](https://docs.google.com/document/d/11Wg-uL75ypU5eNu2p_xh9gspmbGtmLzmdq5VfPHBirE/edit#heading=h.x2qu20cktltz)" and "[by](https://docs.google.com/document/d/11Wg-uL75ypU5eNu2p_xh9gspmbGtmLzmdq5VfPHBirE/edit#heading=h.bjnftdj471t6)" fields may be checked as well, depending on the policy.
4. If the Claim Clearinghouse decides that the Passport meets the access policy for the data in question, the service proceeds to authorize the researcher's use of the data.
    1. Some Claim Clearinghouses will authorize use of the data by changing the researcher's permissions and issuing a cloud-specific access token to read the bytes using their own cloud-native tools and services.
    2. Other Claim Clearinghouses will read the bytes from another service using special access token that it holds which contains permission to do so, then return the bytes back to the researcher.
    3. Yet other varieties of Claim Clearinghouses will just proceed taking an action internally or reading bytes directly from a database in and of itself without much need for downstream access tokens.
5. Some systems will use the Passport once, exchange it for a downstream access token, and not use the Passport again. Other systems will use the Passport multiple times until the passport token expires.
    1. Some systems can issue refresh tokens that can be exchanged for new Passport tokens with a fresh set of claims and updated expiry timestamp.
    2. Other systems do not issue refresh tokens, and the only option to get a new Passport is to have the user do a fresh login (OIDC Authorization Flow) to fetch a new Passport.

## Flow Of Claims

![alt text](https://github.com/ga4gh-duri/assets/img/flow_of_claims.png "Flow of Claims")

## Why so many expiry timestamps?

OIDC tokens have an "exp" standard claim to represent when the token expires. This is separate from the expiry time of claims themselves, which have  an "expires" field for when that claim expires. These different types of expiry timestamps serve different purposes:

- The "exp" timestamp is the overall token's lifetime. Claim Clearinghouses should reject such tokens outright and not look at any other contents once a token has expired.
- The "expires" timestamp allows each claim to represent when the Claim Authority needs a Claim Clearinghouse.

There are several advantages of this approach:

- Passport issuers can issue tokens that are short lived to reduce damage of leaked or stolen tokens, yet carry the intent of Claim Authority to allow access for longer periods of time. This is especially important when refresh tokens are not feasible.
- Claims can be cached by intermediary Identity Brokers and understand the Claim Authority's intent for how long they can be cached before they expire. This can reduce the number of login flows the user needs to go through to collect claims from multiple, federated sources.
- Implementations can encode claims using standard libraries that do not need to understand how to sort out the difference between the expiry of individual claims and how that relates to the expiry of the tokens.
- The understanding of the duration needed before expiry can be done on a claim by claim basis by the Claim Clearinghouse alone. The upstream Identity Brokers do not need to understand the various access scenarios to know how to limit expiry when they do not fully understand the use cases and requirements.

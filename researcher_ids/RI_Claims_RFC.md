<h1>GA4GH Researcher Identity & Access Claims (FROZEN RFC)</h1>


**Work Stream Name**: Data Use and Researcher Identity

**Product Name**: Researcher Identity & Access Claims (a.k.a. “RI Claims”)

**Product Description: **This document provides the GA4GH technical specification for 

<p id="gdcalert1" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: undefined internal link (link text: "GA4GH Researcher Identity Claims"). Did you generate a TOC? </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert2">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>

[GA4GH Researcher Identity Claims](#heading=h.5j4id9dmcpvz) to be consumed by 

<p id="gdcalert2" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: undefined internal link (link text: "Claim Clearinghouses"). Did you generate a TOC? </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert3">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>

[Claim Clearinghouses](#heading=h.xw365l61d6wv) in a standardized approach to determine whether or not data access should be granted. Additionally, the specification provides guidance on 

<p id="gdcalert3" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: undefined internal link (link text: "encoding of Registered Access claims"). Did you generate a TOC? </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert4">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>

[encoding of Registered Access claims](#heading=h.z7gm6m7vr2pk) as defined in the “[Registered access: authorizing data access](https://www.nature.com/articles/s41431-018-0219-y)” publication.

**Co-Chairs of Product Subgroup**: Stephanie Dyke (McGill) & Craig Voisin (Google)


[TOC]


<h2>Conventions and Terminology</h2>


The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in[ RFC 2119](https://tools.ietf.org/html/rfc2119).

<h4>**Researcher Identity Claim (“RI Claim”)**</h4>




*   An assertion from a 

<p id="gdcalert4" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: undefined internal link (link text: "Claim Authority"). Did you generate a TOC? </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert5">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>

[Claim Authority](#heading=h.h79hhcau08w5) that is bound to a researcher identity. Claims have various properties or fields that describe the attestations and limitations thereof. These claims can then be bundled together in a 

<p id="gdcalert5" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: undefined internal link (link text: "Passport"). Did you generate a TOC? </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert6">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>

[Passport](#heading=h.553aqob9ijlr).

<h4>**Claim Authority**</h4>




*   The 

<p id="gdcalert6" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: undefined internal link (link text: "source"). Did you generate a TOC? </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert7">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>

[source](#heading=h.7gkkcdjjulcj) of a claim assertion which at a minimum includes the organization associated with asserting the claim, although can optionally identify a sub-organization or a specific 

<p id="gdcalert7" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: undefined internal link (link text: "role"). Did you generate a TOC? </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert8">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>

[role](#heading=h.bjnftdj471t6) within the organization that made the claim.
*   This is NOT necessarily the organization that stores the claim, or the [Identity Broker](https://docs.google.com/document/d/1zzsuNtbNY7agPRjfTe6gbWJ3BU6eX19JjWRKvkFg1ow/edit#heading=h.an88npsnugjl)’s organization that signs the 

<p id="gdcalert8" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: undefined internal link (link text: "passport"). Did you generate a TOC? </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert9">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>

[passport](#heading=h.rpwhja7jcq9l); it is the organization that has the authority to assert the claim on behalf of the user that is responsible for making and maintaining the assertion.

<h4>**Passport**</h4>




*   A bundle of 

<p id="gdcalert9" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: undefined internal link (link text: "researcher identity claims"). Did you generate a TOC? </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert10">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>

[researcher identity claims](#heading=h.5j4id9dmcpvz) that is collected into a [specialized JWT token](https://docs.google.com/document/d/1zzsuNtbNY7agPRjfTe6gbWJ3BU6eX19JjWRKvkFg1ow/edit#heading=h.sbvh8xj8gogg) and signed by an [Identity Broker](https://docs.google.com/document/d/1zzsuNtbNY7agPRjfTe6gbWJ3BU6eX19JjWRKvkFg1ow/edit#heading=h.an88npsnugjl) as per the [GA4GH AAI specification](https://docs.google.com/document/d/1zzsuNtbNY7agPRjfTe6gbWJ3BU6eX19JjWRKvkFg1ow/edit) for the purpose of evaluating authorization.

<h4>**Claim Clearinghouse**</h4>




*   The service consuming claims via a 

<p id="gdcalert10" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: undefined internal link (link text: "Passport"). Did you generate a TOC? </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert11">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>

[Passport](#heading=h.553aqob9ijlr) as defined by the [Claim Clearinghouses section of the GA4GH AAI specification](https://docs.google.com/document/d/1zzsuNtbNY7agPRjfTe6gbWJ3BU6eX19JjWRKvkFg1ow/edit#heading=h.5va9qbe4vsfw).

<h2>Researcher Identity Claim Overview</h2>


<h3>RI Claims Requirements</h3>




1. 

<p id="gdcalert11" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: undefined internal link (link text: "RI Claims"). Did you generate a TOC? </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert12">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>

[RI Claims](#heading=h.5j4id9dmcpvz) and tokens that contain RI Claims MUST conform the the [GA4GH AAI Spec](https://docs.google.com/document/d/1zzsuNtbNY7agPRjfTe6gbWJ3BU6eX19JjWRKvkFg1ow/edit#heading=h.pnom2c7wov36).
2. Each RI Claim MAY be multi-valued.
3. Each RI Claim may have a different expiry.
    *   This allows a token carrying the claims to be short lived (e.g. 10 minutes).
    *   The same document can encode claims for any 

<p id="gdcalert12" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: undefined internal link (link text: "Claim Clearinghouse"). Did you generate a TOC? </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert13">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>

[Claim Clearinghouse](#heading=h.xw365l61d6wv) to evaluate when requesting pre-authorization for a longer duration (e.g. a request can establish intent to access a resource over the next 60 days, even if this access ends up being revoked after 15 days for other reasons).
4. RI Claims MUST have an indication of which organization asserted the claim (i.e. the “

<p id="gdcalert13" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: undefined internal link (link text: "source"). Did you generate a TOC? </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert14">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>

[source](#heading=h.7gkkcdjjulcj)” field), but claims do not indicate individual persons involved in making the assertion (i.e. who assigned/signed the claim) as it is not generally needed to make an access decision.
5. Additional information about claims that is not needed to make an access decision SHOULD not be included in the claim. Auditing and other purposes are not the intent of these standard RI Claims, and must be handled via another means beyond the scope of this specification with sufficient authority to expose such information.
6. All RI Claims within the “ga4gh” scope eligible for release to the requestor MUST be provided. Reasons for limiting exchange may include user approval, contractual limitations, regulatory restrictions, or filtering claims to only the subset needed for a particular purpose, etc.
7. When an [Identity Broker](https://docs.google.com/document/d/1zzsuNtbNY7agPRjfTe6gbWJ3BU6eX19JjWRKvkFg1ow/edit?ts=5b5bc642#heading=h.ufz3k0fqgxh0) receives a request with the “ga4gh” scope, it MUST provide RI claims under the “ga4gh” OIDC token claim as follows:
    *   The Identity Broker collects the claims, potentially from multiple sources including any upstream Identity Brokers, and flattens them into one set.
    *   The Identity Broker signs the token of claims.
    *   Note: a consumer of claims (e.g. a Claim Clearinghouse) accepting the “ga4gh” OIDC token claim signed by a given Identity Broker also accepts the chain of trust that such claims were collected correctly, are ligitimently derived from the sources of authority, and are presented accurately.
8. RI Claims are designed for machine interpretation only to make an access decision and is a non-goal to support rich user interface requirements nor do these claims fully encode the audit trail.
9. An identity can have several affiliations and the permissions can be coupled to one of them using the “

<p id="gdcalert14" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: undefined internal link (link text: "condition"). Did you generate a TOC? </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert15">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>

[condition](#heading=h.opryxxsqpmt5)” field.

<h3>Support for User Interfaces</h3>


(e.g. mapping a URI string to a human-readable description for a user interface.)

For example, a user interface mapping of “[https://doi.org/10.1038/s41431-018-0219-y](https://doi.org/10.1038/s41431-018-0219-y)” to a human readable description such as “this person is a bona fide researcher as described by the Global Alliance for Genomics and Health”.

Support for User Interfaces is not part of this specification. It is a non-goal for this specification to consider the processes that would support user interfaces, such as:



*   String definitions could be provided as a community effort (e.g. on a wiki) if there is some assurance that definitions have not been tampered with.
*   Any such open effort could be made easy to update and allow self-register new string mappings (e.g. affiliation domain name to research organization name)
*   May provide a rich set of internationalization/localization features for clients to consume.

<h2>Claim Object Fields</h2>


Each 

<p id="gdcalert15" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: undefined internal link (link text: "RI claim"). Did you generate a TOC? </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert16">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>

[RI claim](#heading=h.5j4id9dmcpvz) name maps to an array of claim objects within a “ga4gh” root OIDC claim object (see 

<p id="gdcalert16" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: undefined internal link (link text: "example"). Did you generate a TOC? </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert17">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>

[example](#heading=h.recbey6qswyl)). Fields within the claim object are:

<h4>“**value**” [required]</h4>




*   A string that represents the type, process and version of the claim. The format of the string can vary by the 

<p id="gdcalert17" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: undefined internal link (link text: "claim definition"). Did you generate a TOC? </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert18">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>

[claim definition](#heading=h.wg7udglptf1g).
*   For example, ga4gh.ResearcherStatus.value = "[https://doi.org/10.1038/s41431-018-0219-y](https://doi.org/10.1038/s41431-018-0219-y)” represents the Registered Access Bona Fide standard.
*   A Claim Clearinghouse SHOULD match the full string value as part of enforcing its policies for access.

<h4>“**source**” [required]</h4>




*   A 

<p id="gdcalert18" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: undefined internal link (link text: "URL Claim Field"). Did you generate a TOC? </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert19">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>

[URL Claim Field](#heading=h.52dexvbwbode) that provides at a minimum the organization that has asserted the claim. If there is no organization asserting a claim, the “source” MUST be set to "https://ga4gh.org/duri/no_org”.
*   For complex organizations that may require more specific information regarding which part of the organization made the claim, this field MAY also may encode some substructure to the organization that represents the origin of the authority of the claim. When this approach is chosen, then:
    *   The additional substructure MUST only encode the sub-organization or department but no other details or variables that would make it difficult to enumerate the full set of possible values or cause Claim Clearinghouses confusion about which URLs to whitelist.
    *   The additional information SHOULD be encoded into the subdomain or path whenever possible and SHOULD generally avoid the use of query parameters and anchors to represent the sub-organization.

<h4>“**asserted**” [required]</h4>




*   Shortened name for “asserted at”.
*   Seconds since unix epoch of when the 

<p id="gdcalert19" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: undefined internal link (link text: "Claim Authority"). Did you generate a TOC? </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert20">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>

[Claim Authority](#heading=h.h79hhcau08w5) that made the claim (i.e. the entity identified by the [source](https://docs.google.com/document/d/11Wg-uL75ypU5eNu2p_xh9gspmbGtmLzmdq5VfPHBirE/edit?disco=AAAAClo87-0&ts=5cac94bb#heading=h.7gkkcdjjulcj) field and potentially more specific using the optional [by](https://docs.google.com/document/d/11Wg-uL75ypU5eNu2p_xh9gspmbGtmLzmdq5VfPHBirE/edit?disco=AAAAClo87-0&ts=5cac94bb#heading=h.bjnftdj471t6) field, if present).
*   Its use by a Claim Clearinghouse is described in the 

<p id="gdcalert20" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: undefined internal link (link text: "Claim Expiry"). Did you generate a TOC? </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert21">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>

[Claim Expiry](#heading=h.52dexvbwbode) section.

<h4>“**expires**” [required]</h4>




*   Generally, it is seconds since unix epoch of when the 

<p id="gdcalert21" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: undefined internal link (link text: "Claim Authority"). Did you generate a TOC? </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert22">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>

[Claim Authority](#heading=h.h79hhcau08w5) requires such a claim to be no longer valid. A Claim Authority MAY choose to make a claim very long lived. However, an Identity Broker MAY choose an earlier timestamp if it wishes to limit the claim’s duration of use within downstream Claim Clearinghouses. 
*   Represents the expiry of the individual claim itself, not the token that carries it.
*   Its use by a Claim Clearinghouse is described in the 

<p id="gdcalert22" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: undefined internal link (link text: "Claim Expiry"). Did you generate a TOC? </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert23">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>

[Claim Expiry](#heading=h.52dexvbwbode) section.

<h4>“**condition**” [optional on specific RI claims]</h4>




*   A condition on a claim object that indicates it is only valid if the contents of the condition are present elsewhere in the Passport.
*   Fields that are not specified in the condition are not required to match (i.e. any value will be accepted within that field).
*   Format: \


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


*   Condition fields are restricted to only “

<p id="gdcalert23" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: undefined internal link (link text: "value"). Did you generate a TOC? </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert24">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>

[value](#heading=h.vddhgptnqj4f)”, “

<p id="gdcalert24" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: undefined internal link (link text: "source"). Did you generate a TOC? </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert25">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>

[source](#heading=h.7gkkcdjjulcj)”, and “

<p id="gdcalert25" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: undefined internal link (link text: "by"). Did you generate a TOC? </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert26">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>

[by](#heading=h.bjnftdj471t6)” fields (i.e. timestamp fields and conditions on conditions are not permitted).
    *   Note that the “source” in the condition is the expected source of the condition’s claim name and value, and is not the source of the claim to which the condition is attached.
    *   For example, “claimNameA.sourceA” asserts that “sourceA” is the 

<p id="gdcalert26" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: undefined internal link (link text: "Claim Authority"). Did you generate a TOC? </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert27">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>

[Claim Authority](#heading=h.h79hhcau08w5) of “claimNameA” whereas “claimNameA.condition.claimNameB.sourceB” expects that “claimNameB” exists elsewhere in the passport and is provided by “sourceB”.
*   The Claim Clearinghouse MUST verify that for each condition claim and each condition field present, a single corresponding 

<p id="gdcalert27" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: undefined internal link (link text: "RI claim"). Did you generate a TOC? </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert28">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>

[RI claim](#heading=h.5j4id9dmcpvz) and its corresponding 

<p id="gdcalert28" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: undefined internal link (link text: "fields"). Did you generate a TOC? </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert29">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>

[fields](#heading=h.j0tzup2ibl4) match as per the matching algorithms described elsewhere in this specification, along with the following requirements:
    *   A condition field matches when any one string within the specified list matches a corresponding claim’s field in the passport.
    *   All condition fields that are specified MUST match the same claim in the passport.
    *   For example: \


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



         \
Would match a corresponding `AffiliationAndRole` claim within the same passport that has any of the following:

*   `value = "faculty@uni-heidelberg.de" AND by = "so"`
*   `value = "faculty@uni-heidelberg.de" AND by = "system"`
*   `value = "student@uni-heidelberg.de" AND by = "so"`
*   `value = "student@uni-heidelberg.de" AND by = "system"`
*   The Condition field MUST NOT be present within a claim object unless a 

<p id="gdcalert29" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: undefined internal link (link text: "claim’s definition"). Did you generate a TOC? </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert30">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>

[claim’s definition](#heading=h.wg7udglptf1g) explicitly indicates it is optional.

<h4>“**by**” [optional]</h4>




*   The level or type of authority within the “source” organization that is asserting the claim.
*   A Claim Clearinghouse MAY use this field as part of an authorization decision based on the policies that it enforces.
*   Fixed vocabulary values for this field are:
    *   **<code>self</code></strong>: The identity for which the claim is being made and the person who made the claim is the same person.
    *   <strong><code>peer</code></strong>: A person, who has the same ResearcherStatus as this claim, has made this assertion. The “source” field represents the peer’s organization that is asserting the claim (which isn’t necessarily the same as the identity’s home organization).
    *   <strong>system</strong>: The person’s home organization’s information system has asserted the claim.
    *   <strong><code>so</code></strong>: The person (also known as “signing official”) who authorized this claim is within the “source” organization and at the time the claim was issued possessed direct authority (as part of their formal duties) to bind the organization to their assertion that the identity has met the policies indicated by this claim within the context of its “value” field.
    *   <strong><code>dac</code></strong>: A Data Access Committee or other authority that is responsible as a grantee decision-maker for the given “value” and “source” field pair.
*   If this field is not provided, then none of the above values can be assumed as the level or type of authority is “unknown”. Any policy expecting a specific value as per the list above MUST fail to accept an “unknown” value.

<h3>URL Claim Fields</h3>


A 

<p id="gdcalert30" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: undefined internal link (link text: "claim object field"). Did you generate a TOC? </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert31">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>

[claim object field](#heading=h.j0tzup2ibl4) that is defined as being of URL format with the following limitations:



1. For the purposes of evaluating access, the URL MUST be treated as a simple unique persistent string identifier.
2. The URL is a canonical identifier and as such it is important that Claim Clearinghouses MUST match this identifier consistently using a case-sensitive full string comparison.
    *   Note that these URLs SHOULD use “https” in a canonical identifier even if the human readable document will resolve using either scheme.
    *   Research institutions are encouraged to use a persistent URL pointing to established organizational ontology URL such as a [GRID URL](https://grid.ac/institutes) as their canonical “source” URL.
3. The URL SHOULD also be as short as reasonably possible while avoid collisions, and MUST NOT exceed 255 characters.
4. The URL MUST NOT be followed by the algorithm making an access decision.
5. URLs SHOULD resolve to a human readable document for a policy maker to reason about.

<h3>Claim Expiry</h3>


In addition to any other policy restrictions that a Claim Clearinghouse may enforce, Claim Clearinghouses that provide access for a given duration provided by the user (excluding any revocation policies) MUST enforce one of the following algorithm options to ensure that claim expiry is accounted for:

**Option A**: use the following algorithm to determine if the RI Claim is valid for the entire duration of the requested duration:

	`now()+requestedTTL < min("claim.expires", "claim.asserted"+maxAuthzTTL)`

Where:



*   `requestedTTL` represents the duration for which access is being requested. Alternatively a solution may choose to have a stronger revocation policy instead of requiring such a duration.
*   `maxAuthzTTL` represents any additional expiry policy that the Claim Clearinghouse may choose to enforce. If this is not needed, it can effectively ignored by using a large number of years or otherwise have `"claim.asserted"+maxAuthzTTL` removed and simplify the right hand side expression accordingly.

**Option B**: if tokens are sufficiently short lived and the authorization system has an advanced revocation scheme that does not need to specify a `maxAuthzTTL` as per Option A, then the check can be simplified:

	`now()+accessTokenTTL < claim.expires`

Where:



*   `accessTokenTTL` represents the duration for which an access token will be accepted and is bounded by the next refresh token cycle and/or any larger propagation delay before access is revoked, which needs to be assessed based on the revocation model.

<h2>GA4GH Researcher Identity Claim Definitions</h2>


<h3>ga4gh.AffiliationAndRole</h3>




*   The Identity’s role within the identity’s affiliated institution as specified by [eduPersonScopedAffiliation](http://software.internet2.edu/eduperson/internet2-mace-dir-eduperson-201602.html#eduPersonScopedAffiliation) has controlled multi-valued vocabulary: \
faculty, student, staff, alum, member, affiliate, employee, library-walk-in.
*   The controlled vocabulary defined in [eduPersonAffiliation](http://software.internet2.edu/eduperson/internet2-mace-dir-eduperson-201602.html#eduPersonAffiliation) is extended with the following extra values:

<table>
  <tr>
   <td>
<strong>Value</strong>
   </td>
   <td><strong>Description</strong>
   </td>
  </tr>
  <tr>
   <td>industry-researcher
   </td>
   <td>The person is a health/medical/biomedical/biology researcher or teacher in their home organization.
<p>
The intention is that the primary focus of the person in his/her home organization is in research and/or education.
<p>
Note. This attribute value is for users in the private sector.
   </td>
  </tr>
  <tr>
   <td>clinical-care-professional
   </td>
   <td>The person is a clinical care professional, such as a medical practitioner, in their home organization. This person provides care directly to patients, virtually or in person.
   </td>
  </tr>
</table>




*   Example value: [faculty@cam.ac.uk](mailto:faculty@cam.ac.uk)
*   Having no AffiliationAndRole claim covers citizen scientist that have no institutional affiliation.
*   If the role is known to be within the domain of faculty, staff, student, and other persons with a full set of basic privileges but without the context of being able to name a specific role more precisely, then the RI Claim issuer can use the more general role of “member” (as defined in [eduPerson](http://software.internet2.edu/eduperson/internet2-mace-dir-eduperson-201602.html#eduPersonAffiliation)): “_"Member" is intended to include faculty, staff, student, and other persons with a full set of basic privileges that go with membership in the university community (e.g., they are given institutional calendar privileges, library privileges and/or vpn accounts). It could be glossed as "member in good standing of the university community. The "member" affiliation MUST be asserted for people carrying one or more of the following affiliations: faculty or staff or student or employee”_

<h3>ga4gh.AcceptedTermsAndPolicies</h3>




*   The set of unique identifiers in the form of URLs that indicate that a researcher or their organization has acknowledged the specific terms and conditions indicated by the URL.
*   The URLs SHOULD resolve to a human readable web page that describes the terms and policies. The description MUST be readable within the environment where the claims are consumed.
*   Example value: “[https://doi.org/10.1038/s41431-018-0219-y](https://doi.org/10.1038/s41431-018-0219-y)” acknowledges the ethics terms as needed for 

<p id="gdcalert31" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: undefined internal link (link text: "Registered Access"). Did you generate a TOC? </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert32">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>

[Registered Access](#heading=h.z7gm6m7vr2pk) Bona Fide researcher status.
*   MUST include “

<p id="gdcalert32" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: undefined internal link (link text: "by"). Did you generate a TOC? </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert33">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>

[by](#heading=h.bjnftdj471t6)” field.

<h3>ga4gh.ResearcherStatus</h3>




*   Unique identifiers in the form of URLs that indicate that the person has been acknowledged to be a researcher of a particular type or standard.
*   The “value” field of the claim indicates the minimum standard and/or type of researcher that describes the person represented by the given identity.
*   The URLs SHOULD resolve to a human readable web page that describes the process that has been followed and the qualifications this person has met.
*   Example value: “[https://doi.org/10.1038/s41431-018-0219-y](https://doi.org/10.1038/s41431-018-0219-y)” acknowledges the registration process as needed for 

<p id="gdcalert33" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: undefined internal link (link text: "Registered Access"). Did you generate a TOC? </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert34">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>

[Registered Access](#heading=h.z7gm6m7vr2pk) Bona Fide researcher status.

<h3>ga4gh.ControlledAccessGrants</h3>




*   A list of datasets or other objects for which controlled access has been granted to this researcher.
*   The “source” field contains the access grantee organization
*   MUST include “

<p id="gdcalert34" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: undefined internal link (link text: "by"). Did you generate a TOC? </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert35">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>

[by](#heading=h.bjnftdj471t6)” field.
*   This claim MAY include a “

<p id="gdcalert35" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: undefined internal link (link text: "condition"). Did you generate a TOC? </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert36">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>

[condition](#heading=h.opryxxsqpmt5)” field.

<h2>Encoding Registered Access</h2>




*   To meet the requirements of [Registered Access](https://www.nature.com/articles/s41431-018-0219-y) to data, a user needs to have **all** of the following claims:
    *   Meeting the ethics requirements is represented by <code>ga4gh.AcceptedTermsAndPolicies.value= \
    "[https://doi.org/10.1038/s41431-018-0219-y](https://doi.org/10.1038/s41431-018-0219-y)"</code>
    *   Meeting the bona fide status is represented by <code>ga4gh.ResearcherStatus.value= \
    "[https://doi.org/10.1038/s41431-018-0219-y](https://doi.org/10.1038/s41431-018-0219-y)"</code>
*   The 

<p id="gdcalert36" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: undefined internal link (link text: "Claim Clearinghouse"). Did you generate a TOC? </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert37">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>

[Claim Clearinghouse](#heading=h.xw365l61d6wv) (e.g. to authorize a registered access beacon) needs to evaluate the multiple claims listed above to ensure their values match before granting access.

<h2>Claim and Token Revocation</h2>


As per the [GA4GH AAI Specification on Token Revocation](https://docs.google.com/document/d/1zzsuNtbNY7agPRjfTe6gbWJ3BU6eX19JjWRKvkFg1ow/edit#heading=h.4sjj6uuxbok), the following mechanisms are available within RI Claims:



1. Claims have an 

<p id="gdcalert37" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: undefined internal link (link text: "asserted"). Did you generate a TOC? </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert38">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>

[asserted](#heading=h.x2qu20cktltz) field to allow downstream policies to limit the life, if needed, of how long assertions will be accepted for use with access and refresh tokens.
2. Claims have an 

<p id="gdcalert38" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: undefined internal link (link text: "expires"). Did you generate a TOC? </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert39">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>

[expires](#heading=h.tdge5487ert9) field to allow Claim Clearinghouses to limit the life of access and refresh tokens.

 

At a minimum, these RI Claim fields MUST be checked by all Claim Clearinghouses and systems MUST be in place to take action to remove access by the expiry timestamp or shortly thereafter propagation of these permission changes may require some reasonable delay. Systems implementing RI Claims can also employ other mechanisms outlined in the GA4GH AAI Specification. Systems employing RI Claims MUST provide mechanisms to limit the life of access, and specifically MUST conform to the GA4GH AAI Specification requirements in this regard.

<h2>Example RI Claims</h2>


This non-normative example illustrates RI claims representing Registered Access bona fide researcher status along with RI claims for access to specific Controlled Access data. These RI Claims would form a Passport when included in a JWT that is signed by an Identity Broker:



*   **AffiliationAndRole**: The person is a member of faculty at Stanford University as asserted by a Signing Official at Stanford.
*   **ControlledAccessGrants**: The person has approved access by the DAC at the National Cancer Institute for datasets 710 and approval for dataset 432 for a dataset from EGA.
    *   In this example, assume dataset 710 does not have a “

<p id="gdcalert39" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: undefined internal link (link text: "condition"). Did you generate a TOC? </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert40">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>

[condition](#heading=h.opryxxsqpmt5)” based on the AffiliationAndRole because the system that is asserting the claim has an out of band process to check the researcher’s affiliation and role and withdraw the dataset 710 claim automatically, hence it does not need the condition to accomplish this.
    *   In this example, assume that dataset 432 does not use an out of band mechanism to check affiliation and role, so it makes use of the RI “

<p id="gdcalert40" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: undefined internal link (link text: "condition"). Did you generate a TOC? </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert41">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>

[condition](#heading=h.opryxxsqpmt5)” mechanism to enforce the affiliation and role. The dataset 432 claim is only valid if accompanied with a valid AffiliationAndRole claim for “faculty@med.stanford.edu”.
*   **AcceptedTermsAndPolicies**: The person has accepted the Ethics terms and conditions as defined by Registered Access. They took this action themselves.
*   **ResearcherStatus**: A Signing Official at Stanford Medicine has asserted that this person is a bona fide researcher as defined by Registered Access.

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
    "value": "https://doi.org/10.1038/s41431-018-0219-y",
    "source": "https://grid.ac/institutes/grid.240952.8",
    "by": "self",
    "asserted": 1549680000,
    "expires": 1581208000
],
"ResearcherStatus": [
    "value": "https://doi.org/10.1038/s41431-018-0219-y",
    "source": "https://grid.ac/institutes/grid.240952.8",
    "by": "so",
    "asserted": 1549680000,
    "expires": 1581208000
]
}
```

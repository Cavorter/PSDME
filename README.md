# PSDME

This is a wrapper module for the [DNS Made Easy API](https://api-docs.dnsmadeeasy.com/). The codebase is forked from earlier work by [RagingPuppies](https://github.com/RagingPuppies/PSMadeEasy) with substantial changes including use of approved verbs and a more fleshed out module structure. Many thanks to them for doing a pretty solid authentication implementation which saved me a ton of time!

While I do intend to come back around to implement tests and finish refactoring the older functions I'm leaving it in the current state since it has the functionality I require for a current project.

# Usage

Be default after loading the module functions will interact with the Sandbox version of the API at DNS Made Easy. To interact with the production API use `Set-DMESandboxMode -Mode Production`. To revert to the Sandbox API use `Set-DMESandboxMode -Mode Sandbox`.

Most functions require a `-Credential` parameter that should be a PSCredential object with the username set to the account API Key and the password set to the related secret.

**NOTE!** DNS Made Easy does [implement a rate limit](https://api-docs.dnsmadeeasy.com/#f6f3c489-422d-4cf0-bccb-1933e6d655ac) and this module does **NOT CURRENTLY** implement any way to monitor current activity though that should be pretty easy to do later by keeping an eye on the value of `x-dnsmerequestsRemaining` in the response header.

# Functions

- `Get-DMERecord`: Retrieves one or more records from a zone.
- `Get-DMESandboxMode`: Returns the current API target ("Production" or "Sandbox")
- `Get-DMEZone`: Retrieves one or more zones.
- `Set-DMEREcord`: Updates one or more existing zone records.
- `Set-DMESandboxMode`: Sets the current API target.
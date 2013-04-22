# BasecampKit

BasecampKit is the product of project I was working on a long time ago that never shipped.  It should handle all of the networking and models of the Version 1 Basecamp Next API.  BasecampKit does not currently handle any authorization/authentication, it assumes that you have access to an account and have passed that account's identifier to BasecampKit.

# Dependencies

BasecampKit has two dependencies, AFNetworking and Google's NSString+HTML class.  These are included in the libs folder so if you already have them in your project then you should just be able to leave that folder out.

# Initialization

Initializing BasecampKit is as easy calling
   [[Basecamp sharedCamp] setAccountID:myAccountID];

After the account id is set you should be able to call almost all of the methods described in the header and be returned the appropriate object(s).

# License 

BasecampKit is released under the [MIT license](https://github.com/nothingmagical/cheddarkit/blob/master/LICENSE).  Please feel free to ignore the license information in the source, I just haven't gotten around to changing that yet.


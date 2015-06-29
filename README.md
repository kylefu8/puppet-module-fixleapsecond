# fixleapsecond module #

===

# Compatibility #

Puppet v3 with Ruby 1.8.7 and 1.9.3

## OS Distributions ##

This module is supported on the following systems with Puppet v3 and Ruby 1.8.7, 1.9.3, 2.0.0 and 2.1.0.

* EL 5
* EL 6
* Suse 10
* Suse 11

===

# Parameters #

enable_fix (boolean)
---------------------------
The switch for this module.
Set to 'true' to turn on the functions.

- *Default*: false

use_workaround (boolean)
-----------------------
The switch for work around.
'true' for use the work around before leap second.
'false' for use the work around after leap second(restore the original setting).

- *Default*: false


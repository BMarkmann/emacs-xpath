emacs-xpath
===========

Emacs utility to evaluate XPath against XML

Runs a Perl server (listens on port 5000 by default) that takes a chunk of XML and an XPath expression to evaluate the result.  Defines an Emacs function 'eval-xpath' (highlight the XML in a buffer and enter the XPath when prompted).

Installation
============

Use CPAN to install the required Perl modules.  You need at a minimum:

- XML::XPath
- XML::XPath::XMLParser
- IO::Socket::INET
- Try::Tiny

I put the code from xpath.el into my .emacs file, but you can load it however you want.

Usage
=====

Run the "xpath-server.pl" script (modify the run-xpath-server.sh script for your environment; it'll run the server and swallow the output).

Highlight some XML and hit M-x eval-xpath.  You'll be prompted for an XPath expression.  Once you enter it, the result will be displayed in a buffer in 'nxml mode, wrapped in "result" tags.

To change the port the server runs on, you'll have to edit both the xpath-server.pl file and xpath.el file to change 5000 to some other port.

Random Notes
============

Free free to send any bugs / requested features my way, and I'll try to find time to implement them as appropriate.

I initially intended to patch Emacs' xml.c and rebuild, but this seemed simpler.  Of course, this introduces an external dependency, but... oh well.  Maybe later.

- Bill 


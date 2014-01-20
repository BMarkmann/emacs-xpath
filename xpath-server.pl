#!/usr/bin/perl -w

use XML::XPath;
use XML::XPath::XMLParser;

use IO::Socket::INET;

use Try::Tiny;

my $listen_port = 5000;
my $data_delimiter = '000000000000000000000000';

my $request_count = 0;

# flush after every write
$| = 1;

my ($socket, $client_socket);
my ($peer_address, $peer_port);

# listen on port listen_port
$socket = new IO::Socket::INET (
    LocalHost => '127.0.0.1',
    LocalPort => $listen_port,
    Proto => 'tcp',
    Listen => 5,
    Reuse => 1
    ) or die "ERROR in socket creation: $!\n";

print "Waiting for client connection on port $listen_port\n";

while(1)
{
    # waiting for new client connection.
    $client_socket = $socket->accept();

    try
    {
        # get the host and port number of newly connected client.
        $peer_address = $client_socket->peerhost();
        $peer_port = $client_socket->peerport();

        print "(" . ++$request_count . ") Accepted new client connection from: $peer_address, $peer_port\n";

        my ($input_data, $xml_data, $xpath_data);
        $client_socket->recv($input_data,1048576);
        ($xml_data, $xpath_data) = split(/$data_delimiter/, $input_data);

        print "Request:\n";
        print "XML data: $xml_data\n";
        print "XPath: $xpath_data\n";

        my $xp = XML::XPath->new(xml => $xml_data);
        my $nodeset = $xp->find($xpath_data);

        print "Result:\n";
        my $output = "";
        foreach my $node ($nodeset->get_nodelist) 
        {
            $output = $output . XML::XPath::XMLParser::as_string($node);
        }
        print "$output\n\n";
        print $client_socket $output;
    }
    catch
    {
        warn "caught error: $_";
    }
    finally
    {
        $client_socket->close();
    }
}

$socket->close();





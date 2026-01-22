package rcprojects.simulations;

import inet.node.inet.StandardHost;
import inet.networklayer.configurator.ipv4.Ipv4NetworkConfigurator;

network ExtPingNet
{
    submodules:
        configurator: Ipv4NetworkConfigurator {
            parameters:
                @display("p=100,60");
                config = xmldoc("config.xml");
                // keep it simple; we only need an address on the ext iface
                addStaticRoutes = false;
        }
        host1: StandardHost {
            parameters:
                @display("p=100,160");
        }
    connections allowunconnected:
        // No OMNeT++ cable needed: packets go via the real interface (veth-sim).
}
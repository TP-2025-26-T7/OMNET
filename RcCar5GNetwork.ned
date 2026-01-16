package tp7.myrcproject;

import inet.networklayer.configurator.ipv4.Ipv4NetworkConfigurator;
import inet.networklayer.ipv4.RoutingTableRecorder;
import inet.node.inet.Router;
import inet.node.inet.StandardHost;
import inet.node.ethernet.EthernetLink;
import inet.node.ethernet.EthernetHub;

import simu5g.world.radio.LteChannelControl;
import simu5g.common.binder.Binder;
import simu5g.common.carrierAggregation.CarrierAggregation;
import simu5g.nodes.Upf;
import simu5g.nodes.gNodeB;
import simu5g.nodes.NrUe;
import simu5g.nodes.BackgroundCell;

network RcCar5GNetwork
{
    parameters:
        int numCars = default(3);
        int numBgCells = default(0);
        @display("i=block/network2;bgb=1000,1000");

    submodules:
        channelControl: LteChannelControl {
            @display("p=50,25;is=s");
        }
        extHub: EthernetHub {
    		@display("p=150,80");
		}
        routingRecorder: RoutingTableRecorder {
            @display("p=50,75;is=s");
        }
        configurator: Ipv4NetworkConfigurator {
            @display("p=50,125");
        }
        binder: Binder {
            @display("p=50,175;is=s");
        }
        carrierAggregation: CarrierAggregation {
            @display("p=50,258;is=s");
        }
        controller: StandardHost {
            @display("p=212,118;is=n;i=device/server");
        }
        router: Router {
            @display("p=363,115;i=device/smallrouter");
        }
        upf: Upf {
            @display("p=527,116");
        }
        coreUpf: Upf {
            @display("p=725,118");
        }
        gnb: gNodeB {
            @display("p=726,277;is=vl");
        }
        bgCell[numBgCells]: BackgroundCell {
            @display("p=416,277;is=vl");
        }
        car[numCars]: NrUe {
            @display("p=628,411;i=vehicle/car");
        }
    connections:
        controller.pppg++ <--> EthernetLink <--> router.pppg++;
        router.pppg++      <--> EthernetLink <--> upf.filterGate;
        upf.pppg++         <--> EthernetLink <--> coreUpf.pppg++;
        coreUpf.pppg++     <--> EthernetLink <--> gnb.ppp;
        controller.ethg++ <--> EthernetLink <--> extHub.ethg++;
}
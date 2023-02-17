//
//  Checklist.swift
//  RvChecklist
//
//  Created by Ron Lisle on 11/13/21.
//

struct Checklist {
    static let initialChecklist = [
        
        // MAINTENANCE
        ChecklistItem(
            id: 0,
            key: "genRun",
            name: "Run Generator",
            category: .maintenance,
            description: "<p>Periodically run the generator</p><ul><li>Run under load for 20-30 minutes</li></ul>",
            isDone: true),
        
        ChecklistItem(
            id: 0,
            key: "genChangeOil",
            name: "Change Generator Oil",
            category: .maintenance,
            description: "<p>Change the generator oil every 150 hours or annually</p></ul><li>SAE 15W40 (OnaMax) 10°-100°F </li><li>SAE 30 above 32°F</li><li>SJ, SH, or SG Performance class</li><li>May be combined with CH-4, CG-4, or CF-4</li><li>eg. SJ/CH-4</li></ul>",
            isDone: true),
        ChecklistItem(
            id: 0,
            key: "genAirFilter",
            name: "Replace Generator Air Filter",
            category: .maintenance,
            description: "<p>Change generator air filter every 150 hours</p><p>Change more frequently if dusty environment</p>",
            isDone: true),
        ChecklistItem(
            id: 0,
            key: "genSparkPlugs",
            name: "Replace Generator Spark Plugs",
            category: .maintenance,
            description: "<p>Change generator spark plugs every 500 hours or 3 years</p>",
            isDone: true),
        ChecklistItem(
            id: 0,
            key: "genSparkArrestor",
            name: "Clean Generator Spark Arrestor",
            category: .maintenance,
            description: "<p>Clean generator spark arrestor every 50 hours</p>",
            isDone: true),
        ChecklistItem(
            id: 0,
            key: "genFuelFilter",
            name: "Replace Generator Fuel Filter",
            category: .maintenance,
            description: "<p>Change generator fuel filter every 500 hours</p><p>Change sooner if performance deteriorates or every 3 years</p>",
            isDone: true),
        
        // PRE-TRIP 1000-1999
        ChecklistItem(
            id: 0,
            key: "startList",
            name: "Start Checklist",
            category: .pretrip,
            description: "Start a new checklist"),
        ChecklistItem(
            id: 0,
            key: "checkTires",
            name: "Check Tires",
            category: .pretrip,
            description: "<h1>Check all tire pressures</h1><ul><li>Truck front: 80 psi</li><li>Truck rear: 65 psi</li><li>RV 110 psi</li></ul>"),
        ChecklistItem(
            id: 0,
            key: "dumpTanks",
            name: "Dump Tanks",
            category: .pretrip,
            description: "Dump both black and gray tanks"),
        ChecklistItem(
            id: 0,
            key: "fillWater",
            name: "Fill Water Tank",
            category: .pretrip,
            description: "Fill fresh water tank appropriately"),
        ChecklistItem(
            id: 0,
            key: "fuel",
            name: "Fill-up Fuel Tanks",
            category: .pretrip,
            description: "Calculate amount of fuel needed, and fill tanks appropriately.<p>For shorter trips, get enough for entire trip. <p>For example:<ul><li>Inks Lake is 68 miles.</li><li>Figure 7.5 if hilly, or 9-11 if < 65 mph.</li><li>Main tank is 50 gallons</li><li>Aux tank about 50 more.</li><li>So fill main tank if entire trip < 500 miles.</li><li>Fill aux also if < 1000 miles.</li></ul>"),
        ChecklistItem(
            id: 0,
            key: "fillPropane",
            name: "Fill-up Propane Tanks",
            category: .pretrip,
            description: "Check the level of propane in the 2 propane tanks. Fill tanks if needed.<p>Normally only 1 tank is used at a time. The tank selector points to the primary tank. When it is empty, the gauge will show red. Switch the selector to the other tank and have the empty tank filled while running on other tank.<p>If propane will not be available at destination, may consider filling both tanks.<p>The tank selector switch is on the right side and selects the primary tank. It will show red if the tank is empty, but will draw from the alternate tank if both valves are open.<p>Do not switch the selector until the primary tank is empty. Otherwise both tanks may become partially empty, making it difficult to know how much propane is available."),
        ChecklistItem(
            id: 0,
            key: "checkRoof",
            name: "Inspect Roof",
            category: .pretrip,
            description: "Ensure everything on roof looks ok. Check for leaks, cracks or other damage"),
        ChecklistItem(
            id: 0,
            key: "checkUnderRV",
            name: "Inspect Under RV",
            category: .pretrip,
            description: "Ensure everything under RV looks ok. Check for leaks, and verify flaps under RV not coming loose."),
        ChecklistItem(
            id: 0,
            key: "planRoute",
            name: "Plan Route",
            category: .pretrip,
            description: "Plan route for the trip.<p>Use RV Trip Wizard to identify stops.<p>Identify fuel requirements."),
        ChecklistItem(
            id: 0,
            key: "birdFeeders",
            name: "Bird Feeders",
            category: .pretrip,
            description: "Stow bird feeders and welcome signs"),
        
        // DEPARTURE 2000-2999
        ChecklistItem(
            id: 0,
            key: "tvStrap",
            name: "Secure TV Strap",
            category: .departure,
            description: "Secure TV using strap. Insert a stuffed toy or other soft material between strap and TV to prevent scratching",
            imageName: "TODO"),
        ChecklistItem(
            id: 0,
            key: "referLock",
            name: "Refrigerator Lock",
            category: .departure,
            description: "Insert refrigerator locking device.",
            imageName: "TODO"),
        ChecklistItem(
            id: 0,
            key: "deskDisplay",
            name: "Desk and Display",
            category: .departure,
            description: "Secure all items on the desk, and tie down monitor arm",
            imageName: "TODO"),
        ChecklistItem(
            id: 0,
            key: "iceMachine",
            name: "Secure Ice Machine",
            category: .departure,
            description: "Secure Ice Machine using bungie cord. Bit hooks into holes in bottom of the Ice Machine shelf",
            imageName: "TODO"),
        ChecklistItem(
            id: 0,
            key: "starlinkAntenna",
            name: "Secure StarLink Antenna",
            category: .departure,
            description: "Secure Dishy McFlatface",
            imageName: "TODO"),
        ChecklistItem(
            id: 0,
            key: "bedSlideIn",
            name: "Retract Bedroom Slide",
            category: .departure,
            description: "Retract the bedroom slide. Switch is located on front panel",
            imageName: "TODO"),
        ChecklistItem(
            id: 0,
            key: "LRSlidesIn",
            name: "Retract Main Slides",
            category: .departure,
            description: "Retract the living room slides. Switch is located on front panel",
            imageName: "TODO"),
        ChecklistItem(
            id: 0,
            key: "rampAwningIn",
            name: "Retract Ramp Awning",
            category: .departure,
            description: "Disconnect ramp awning arms and slide into end rail. Retrack the ramp awning. Switch is located on rear panel"),
        ChecklistItem(
            id: 0,
            key: "closeRamp",
            name: "Close Ramp",
            category: .departure,
            description: "Remove all furniture on the ramp deck. Roll up carpet. Raise and latch ramp."),
        ChecklistItem(
            id: 0,
            key: "sealRamp",
            name: "Seal Ramp",
            category: .departure,
            description: "Ensure ramp is sealed tight. Insert a wedge or 1x2 under left clamp if needed."),
        ChecklistItem(
            id: 0,
            key: "latchHandles",
            name: "Latch Door Handles",
            category: .departure,
            description: "Close both door handles so they cover door to prevent accidental opening during travel."),
        ChecklistItem(
            id: 0,
            key: "rearAwningIn",
            name: "Retract Rear Awning",
            category: .departure,
            description: "Retract the rear awning. The switch is located on the rear panel."),
        ChecklistItem(
            id: 0,
            key: "frontAwningIn",
            name: "Retract Front Awning",
            category: .departure,
            description: "Retract the front awning. Switch is located on front panel"),
        ChecklistItem(
            id: 0,
            key: "windowAwningIn",
            name: "Retract Window Awning",
            category: .departure,
            description: "Raise the window awning. Untie the strap, and slowly let it out."),
        ChecklistItem(
            id: 0,
            key: "discPropane",
            name: "Disconnect Propane",
            category: .departure,
            description: "Turn off and disconnect big propane tank.<p>Turn off 30 lb tanks while travelling."),
        ChecklistItem(
            id: 0,
            key: "waterHeaterOff",
            name: "Turn Off Water Heater",
            category: .departure,
            description: "Turn off both propane and electric water heater switches. <p>Switches are located on the front panel."),
        ChecklistItem(
            id: 0,
            key: "hitchTruck",
            name: "Connect Truck",
            category: .departure,
            description: "Hitch up trailer to truck.<ol><li>Drop tailgate</li><li>Release 5th wheel hitch handle</li><li>Back in truck until kingpin close to hitch</li><li>Raise landing gear until truck and trailer at same height (-1/2 inch)</li><li>Backup truck until hitch latches</li><li>Insert pin to lock hitch</li><li>Connect trailer electrical cable to side connector inside bed</li><li>Connect safety wire to hitch handle</li><li>Rock truck to ensure good latching</li><ol>"),
        ChecklistItem(
            id: 0,
            key: "removeChocks",
            name: "Remove and stow tire chocks",
            category: .departure,
            description: "Remove all tire chocks.<p>Stow chocks in the basement on each side."),
        ChecklistItem(
            id: 0,
            key: "raiseLG",
            name: "Raise Landing Gear and Level Up",
            category: .departure,
            description: "Raise the Level-Up and front landing gear.<p>Level-up control is in the basement.<p>Select manual, then retract."),
        ChecklistItem(
            id: 0,
            key: "discPower",
            name: "Disconnect Shore Power",
            category: .departure,
            description: "Disconnect A/C power cable, and stow away in box in back of truck"),
        ChecklistItem(
            id: 0,
            key: "photo",
            name: "Take Picture",
            category: .departure,
            description: "Take a picture to remember the date/time and appearance of the stop."),
        ChecklistItem(
            id: 0,
            key: "rearCamera",
            name: "Setup Rear Camera",
            category: .departure,
            description: "Setup iPad in Truck and verify rear camera works. Adjust rear camera if necessary."),
        ChecklistItem(
            id: 0,
            key: "pray",
            name: "Pray",
            category: .departure,
            description: "Pray with thanksgiving for the ability to travel, and asking for a safe trip. Ask God to speak to us along our travels and to open our eyes and hears to hear what God has to say to us as we travel."),
        
        // ARRIVAL 3000-3999
        ChecklistItem(
            id: 0,
            key: "positionRV",
            name: "Position RV",
            category: .arrival,
            description: "Position the RV where desired.<ul><li>Ensure slide-outs are free of obstructions</li><li>Position doors to open onto patios and are not blocked</li><li>Ensure hook-ups will reach</li></ul>"),
        ChecklistItem(
            id: 0,
            key: "openTailgate",
            name: "Open truck tailgate",
            category: .arrival,
            description: "Open truck tailgate. Be careful that tailgate does not hit the RV if the truck is at much of an angle."),
        ChecklistItem(
            id: 0,
            key: "disconnectCables",
            name: "Disconnect Cables",
            category: .arrival,
            description: "Disconnect trailer cable and safety wire.<p>Stow wire and cable into space behind kingpin. Be careful that cable doesn't short out to ground."),
        ChecklistItem(
            id: 0,
            key: "unlatchHitch",
            name: "Unlatch Hitch",
            category: .arrival,
            description: "Remove locking pin, and pull hitch arm forward until it latches."),
        ChecklistItem(
            id: 0,
            key: "lowerLG",
            name: "Lower Landing Gear",
            category: .arrival,
            description: "Position pads under landing gear. Then lower landing gear until kingpin just begins to lift off of the hitch. Switch is located outside the RV on the leading wall under the kingpin."),
        ChecklistItem(
            id: 0,
            key: "connectPower",
            name: "Connect Shore Power",
            category: .arrival,
            description: "Connect power cable from cable in box in back of truck"),
        ChecklistItem(
            id: 0,
            key: "stepsDown",
            name: "Restore Door Steps and Handles",
            category: .arrival,
            description: "Open both door handles and lower steps."),
        ChecklistItem(
            id: 0,
            key: "bedSlideOut",
            name: "Extend Bedroom Slide",
            category: .arrival,
            description: "Extend the bedroom slide.<p>Switch is located on front panel.<p>Check to ensure nothing has fallen between the slide edges and walls."),
        ChecklistItem(
            id: 0,
            key: "LRSlidesOut",
            name: "Extend Main Slides",
            category: .arrival,
            description: "Extend the living room slides.<p>Switch is located on front panel.<p>Check to ensure nothing has fallen between the slide edges and walls."),
        ChecklistItem(
            id: 0,
            key: "openRamp",
            name: "Open Ramp",
            category: .arrival,
            description: "Restore ramp patio.<ul><li>Lower ramp</li><li>Setup railings</li><li>Replace carpet</li><li>Replace all furniture on the ramp deck</li></ul>"),
        ChecklistItem(
            id: 0,
            key: "rampAwningOut",
            name: "Extend Ramp Awning",
            category: .arrival,
            description: "Extend ramp awning and reconnect ramp awning arms.<p>Switch is located on rear panel"),
        ChecklistItem(
            id: 0,
            key: "rearAwningOut",
            name: "Extend Rear Awning",
            category: .arrival,
            description: "Extend the rear awning. The switch is located on the rear panel."),
        ChecklistItem(
            id: 0,
            key: "frontAwningOut",
            name: "Extend Front Awning",
            category: .arrival,
            description: "Extend the front awning. Switch is located on front panel"),
        ChecklistItem(
            id: 0,
            key: "propaneOn",
            name: "Turn On Propane",
            category: .arrival,
            description: "Turn on 30 lb. tanks when traveling.<p>Tanks are located on both sides of RV near the front<p>While at home, connect large propane tank to quick connect fitting under right side of RV"),
        ChecklistItem(
            id: 0,
            key: "waterHose",
            name: "Connect Water Hose",
            category: .arrival,
            description: "Connect and turn on water hose.<p>Route the hose up through the hole at the bottom of the water closet"),
        ChecklistItem(
            id: 0,
            key: "waterHeaterOn",
            name: "Turn On Water Heater",
            category: .arrival,
            description: "The water heater switch is located on the front panel."),
        ChecklistItem(
            id: 0,
            key: "sewerHose",
            name: "Connect Sewer Hoses",
            category: .arrival,
            description: "Optionally, connected sewer hose to 1 or both sewer fittings.<p>For shorter stays, may skip this, or just connect the front to allow showers.")
    ]
    
}

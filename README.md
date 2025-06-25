# PS2MapComponents
THIS SOFTWARE IS COVERED BY [THIS DISCLAIMER](https://raw.githubusercontent.com/thedges/Disclaimer/master/disclaimer.txt).

This repo provides new LWC based map components to be used in demos

# Installation
Install this repo to your target demo org.

<a href="https://githubsfdeploy.herokuapp.com?owner=thedges&repo=PS2MapComponents&ref=main">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

## PSRecordLocator
Use this component to drop on record to show current location. You can move map to new location and component will do a reverse address lookup based on location of crosshair. Click on address at bottom of window to set the record lat/lng and address fields. The following is example of the map component on a record.

![alt text](https://github.com/thedges/PSMapComponents/blob/master/geotest.png "Sample Image")

* Features of the component:
  - If lat/lng location already exists on record, it will center on that location
  - Move the map to new location and address will show in bottom of map. Click on address location and it will set fields on the record. Address will disappear once you have set it.
  - A "find me" icon will show in top-right of map. This icon shows once the component captures your current lat/lng location. Just click this to move to your current location.
* The component configuration fields are:

| Parameter | Description |
|-----------|-------------|
| <b>SObject Field For Latitude</b> | SObject field that stores the latitude value |
| <b>SObject Field For Longitude</b> | SObject field that stores the longitude value |
| <b>SObject Field For Full Address</b> | SObject field that stores full address in one value |
| <b>SObject Field For Street</b> | SObject field that stores the street |
| <b>SObject Field For City</b> | SObject field that stores the city |
| <b>SObject Field For State</b> | SObject field that stores the state |
| <b>SObject Field For Postal/Zipcode</b> | SObject field that stores postal code |
| <b>Map Center Latitude</b> | Default latitude for center of map |
| <b>Map Center Longitude</b> | Default longitude for center of map |
| <b>Map Zoom Level</b> | Default map zoom level |
| <b>Height of map in pixels</b> | Height of map in pixels |

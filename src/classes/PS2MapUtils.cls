public with sharing class PS2MapUtils
{
  @AuraEnabled
  public static Address reverseGeocode(Decimal lat, Decimal lng)
  {
    return reverseGeocodeEsri(lat, lng);
  }

  public static Address reverseGeocodeEsri(Decimal lat, Decimal lng)
  {
    System.debug('lat=' + lat + ' lng=' + lng);
    String tmpStr = '';

    Http h = new Http();

    // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
    HttpRequest req = new HttpRequest();
    req.setEndpoint('https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/reverseGeocode?location=' + lng.setScale(8) + ',' + lat.setScale(8) + '&f=json');
    req.setMethod('GET');

    // Send the request, and return a response
    System.debug('reverseGeocodeEsri::Sending request...');
    HttpResponse res = h.send(req);
    System.debug('response=' + res.getBody());

    EsriAddressWrapper addrWrapper = (EsriAddressWrapper)JSON.deserialize(res.getBody(), EsriAddressWrapper.class);

    Address addr = new Address();
    //addr.fullAddress = addrWrapper.address.LongLabel;

    if (addrWrapper.address != null)
    {
      addr.street = addrWrapper.address.Address;
      addr.city = addrWrapper.address.City;
      addr.state = addrWrapper.address.RegionAbbr;
      addr.postal = addrWrapper.address.Postal;

      if (addrWrapper.location != null)
      {
        addr.latitude = addrWrapper.location.y;
        addr.longitude = addrWrapper.location.x;
      }

      tmpstr = '';
      if (addrWrapper.address.Address != null && addrWrapper.address.Address != '')
      {
        addr.fullAddress = addrWrapper.address.Address + ', ' + addrWrapper.address.City + ', ' + addrWrapper.address.RegionAbbr + ' ' + addrWrapper.address.Postal;
        addr.label = addr.fullAddress;
      }
      else {
        addr.label = '[' + addr.latitude.setScale(6) + ',' + addr.longitude.setScale(6) + ']';
      }
    }


    return addr;
    //return res.getBody();
    //return JSON.serialize(addr);
  }

  @AuraEnabled
  public static String loadRecordLocation(Id recordId, String latField, String lngField, String fullAddressField, String streetField, String cityField, String stateField, String postalField) {
  
    System.debug('loadRecordLocation invoked...');
    Map<String, Object> dataMap = new Map<String, Object>();
   
      Id recId = Id.valueOf(recordId);
      Schema.SObjectType objType = recId.getSObjectType();
      Schema.DescribeSObjectResult dr = objType.getDescribe();

      String querystr = 'SELECT ' + latField + ', ' + lngField + ', ' + fullAddressField + ', ' + streetField + ', ' + cityField + ', ' + stateField + ', ' + postalField + ' FROM ' + dr.getName() + ' WHERE Id=\'' +  recordId + '\'';

      SObject obj = Database.query(queryStr);

      if (obj.get(latField) != null && obj.get(lngField) != null)
      {
        dataMap.put('latitude', obj.get(latField));
        dataMap.put('longitude', obj.get(lngField));
        dataMap.put('fullAddress', obj.get(fullAddressField));
        dataMap.put('street', obj.get(streetField));
        dataMap.put('city', obj.get(cityField));
        dataMap.put('state', obj.get(stateField));
        dataMap.put('postal', obj.get(postalField));
      }
 

    return  JSON.serialize(dataMap);
  }

  @AuraEnabled
  public static void saveRecordLocation(Id recordId, String latField, String lngField, String fullAddressField, String streetField, String cityField, String stateField, String postalField,
                                        Double lat, Double lng, String fullAddress, String street, String city, String state, String postal) {
  
    System.debug('saveRecordLocation invoked...');

    try {
      ////////////////////////////////////
      // get metadata of current object //
      ////////////////////////////////////
      Schema.SObjectType objType = recordId.getSObjectType();
      Schema.DescribeSObjectResult dr = objType.getDescribe();

      /////////////////////////////////////////////////////////
      // create a generic SObject to update values on record //
      /////////////////////////////////////////////////////////
      SObject sObj = Schema.getGlobalDescribe().get(dr.getName()).newSObject();
      sObj.put('Id', recordId);

      if (latField != null && latField != '' && lat != null)  sObj.put(latField, lat);
      if (lngField != null && lngField != '' && lng != null)  sObj.put(lngField, lng);

      if (fullAddressField != null && fullAddress != null)  sObj.put(fullAddressField, fullAddress);
      if (streetField != null && street != null)  sObj.put(streetField, street);
      if (cityField != null && city != null)  sObj.put(cityField, city);
      if (stateField != null && state != null)  sObj.put(stateField, state);
      if (postalField != null && postal != null)  sObj.put(postalField, postal);

      System.debug(JSON.serialize(sobj));

      update sObj;
    } catch (Exception e) {
      throw e;
    }
  }


  public class Address
  {
    @AuraEnabled
    public String label{ get; set; }

    @AuraEnabled
    public String fullAddress{ get; set; }

    @AuraEnabled
    public String street{ get; set; }

    @AuraEnabled
    public String city{ get; set; }

    @AuraEnabled
    public String state{ get; set; }

    @AuraEnabled
    public String postal{ get; set; }

    @AuraEnabled
    public Decimal latitude{ get; set; }

    @AuraEnabled
    public Decimal longitude{ get; set; }

  }

  public class EsriAddressWrapper
  {
    // test
    public EsriAddress address;
    public EsriLocation location;
  }

  public class EsriAddress
  {
    public String Match_addr;
    public String LongLabel;
    public String ShortLabel;
    public String Addr_type;
    public String Type;
    public String PlaceName;
    public String AddNum;
    public String Address;
    public String Block;
    public String Sector;
    public String Neighborhood;
    public String District;
    public String City;
    public String MetroArea;
    public String Subregion;
    public String Region;
    public String RegionAbbr;
    public String Territory;
    public String Postal;
    public String PostalExt;
    public String CntryName;
    public String CountryCode;
  }

  public class EsriLocation
  {
    public Decimal x;
    public Decimal y;
    public EsriSpatialReference spatialReference;
  }

  public class EsriSpatialReference
  {
    public String wkid;
    public string latestWkid;

  }

  public static void test() {
     //String resp = loadRecordLocation('5004p00000Ih3YwAAJ', 'Location__Latitude__s', 'Location__Longitude__s');
  }

}
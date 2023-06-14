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

}
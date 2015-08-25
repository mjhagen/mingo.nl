component {
  this.name = "mingo-nl";
  this.domainName = "home.mingo.nl";
  this.root = "/" & listChangeDelims( getDirectoryFromPath( getCurrentTemplatePath()), "/", "\/" );
  this.mappings["/"] = this.root;

  public void function onRequestStart() {
    var this.domainName = "home.mingo.nl";
    var relocateonce = (
          cgi.server_port_secure == 1
            ? "https"
            : "http"
        ) & "://" & this.domainName & (
          cgi.script_name == "/index.cfm"
            ? "/"
            : cgi.script_name
        ) & (
          len( trim( cgi.query_string )) > 0
            ? "?" & cgi.query_string
            : ""
        );

    if( cgi.server_name != this.domainName ) {
      // location( relocateonce, false, 301 );
    }
  }

  public void function onRequest() {
    // extract template from URL:
    var tpl = listLast( cgi.script_name, "/" );

    // no template provided, set to home page:
    if( listLen( tpl, "/" ) == 0 ) {
      tpl = "home.cfm";
    }

    // store original template in case of 404:
    local["page"] = cfmFile = this.root & "/pages/#tpl#";

    // run page code:
    try {
      savecontent variable="local.body" {
        include "/pages/#tpl#";
      };
    } catch( any e ) {
      // page not found, set template to 404:
      savecontent variable="local.body" {
        include "/pages/404.cfm";
      };
    }

    // assemble page into layout:
    var assembled = "";
    savecontent variable="assembled" {
      include "/parts/layout.cfm";
    }

    // output compressed page to browser:
    compressHTML( assembled );
  }

  public void function compressHTML( string sInput="" ) {
    // replace superfluous whitespace:
    sInput = trim( reReplace( sInput, "\s{2,}|\n+|<!--(.*?)-->", "", "all" ));

    // cfcache( action="clientcache", timespan=createtimespan( 7, 0, 0, 0 ));
    cfheader( name="cache-control", value="max-age=604800" );

    // use gzip when available:
    if( cgi.HTTP_ACCEPT_ENCODING contains "gzip" ) {
      var fileOut = createobject( "java", "java.io.ByteArrayOutputStream" ).init();
      var out = createobject( "java", "java.util.zip.GZIPOutputStream" ).init( fileOut );

      out.write( sInput.getBytes("UTF-8"), 0, len( sInput.getBytes("UTF-8")));
      out.finish();
      out.close();

      cfheader( name="content-encoding", value="gzip" );
      cfheader( name="content-length", value=len( fileout.tobytearray()));

      cfcontent( type="text/html; charset=utf-8", reset="true", variable=fileOut.toByteArray());
    } else {
      writeOutput( sInput );
    }
  }
}
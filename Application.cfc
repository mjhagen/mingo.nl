component {
  this.name="mingo-nl";
  this.mappings["/"] = getDirectoryFromPath( getCurrentTemplatePath());

  public void function onRequestStart() {
    var domainname = "home.mingo.nl";
    var relocateonce = (
          cgi.server_port_secure eq 1
            ? 'https'
            : 'http'
        ) & '://' & domainname & (
          cgi.script_name eq "/index.cfm"
            ? '/'
            : cgi.script_name
        ) & (
          len( trim( cgi.query_string )) gt 0
            ? '?' & cgi.query_string
            : ''
        );

    if( cgi.server_name != domainname ) {
      location( relocateonce, false, 301 );
    }
  }

  public void function onRequest() {
    var local = {};
    var assembled = "";
    var tpl = cgi.PATH_INFO;
        tpl = listLast( tpl, "/" );

    if( listLen( tpl, "/" ) == 0 ) {
      tpl = "home.cfm";
    }

    if( !fileExists( expandPath( '../pages/#tpl#' ))) {
      local.page = tpl;
      tpl = "404.cfm";
    }

    savecontent variable="local.body" {
      include "/pages/#tpl#";
    };

    savecontent variable="assembled" {
      include "/parts/layout.cfm";
    }

    htmlCompressFormat( assembled );
  }

  public void function htmlCompressFormat( string sInput="" ) {
    // replace superfluous whitespace:
    sInput = trim( reReplace( sInput, "\s{2,}|\n+|<!--(.*?)-->", "", "all" ));

    // cfcache( action="clientcache", timespan=createtimespan( 7, 0, 0, 0 ));
    cfheader( name="cache-control", value="max-age=604800" );

    if( cgi.HTTP_ACCEPT_ENCODING contains "gzip" ) {
      var fileOut = createobject("java", "java.io.ByteArrayOutputStream").init();
      var out = createobject("java","java.util.zip.GZIPOutputStream").init( fileOut );

      out.write( sInput.getBytes("UTF-8"), 0, len( sInput.getBytes("UTF-8")));
      out.finish();
      out.close();

      cfheader( name="content-encoding", value="gzip" );
      cfheader( name="content-length", value=len( fileout.tobytearray()));

      cfcontent( type="text/html; charset=utf-8", reset="true", variable="#fileOut.toByteArray()#" );
    } else {
      // at least replace whitespace:
      writeOutput( sInput );
    }

    abort;
  }
}
component {
  this.name = "mingo-nl";
  this.root = listChangeDelims( getDirectoryFromPath( getCurrentTemplatePath( ) ), '/', '\' );
  this.root = listDeleteAt( this.root, listLen( this.root, "/" ), "/" );
  this.mappings[ "/" ] = this.root;
  this.javaSettings = { loadPaths = [ "/lib" ] };

  public void function onApplicationStart( ) {
    structClear( application );
    application[ "pegDownProcessor" ] = createObject( "java", "org.pegdown.PegDownProcessor" ).init( javaCast( "int", 32 ) );
    application[ "cache" ] = { };
  }

  public void function onRequestStart( ) {
    if ( !isNull( url.reload ) ) {
      onApplicationStart( );
    }
    relocateOnce( );
  }

  public void function onRequest( ) {
    var rc = {
      "title" = "",
      "description" = "",
      "keywords" = "",
      "content" = "",
      "body" = ""
    };

    var tpl = listFirst( listLast( cgi.PATH_INFO, "/" ), "." );

    if ( !len( tpl ) ) {
      tpl = "home";
    }

    rc.page = tpl;

    if ( reFind( "\W+", tpl ) ) {
      tpl = "404";
    }

    structAppend( rc, parseMarkdownText( tpl ), true );

    if ( len( rc.content ) ) {
      tpl = "page";
    }

    try {
      savecontent variable="rc.body" {
        include "/pages/#tpl#.cfm";
      };
    } catch ( MissingTemplate e ) {
      savecontent variable="rc.body" {
        include "/pages/404.cfm";
      };
    }

    savecontent variable="local.assembled" {
      include "/parts/layout.cfm";
    }

    htmlCompressFormat( assembled );
  }

  private void function htmlCompressFormat( string sInput = "" ) {
    // replace superfluous whitespace:
    sInput = trim( reReplace( sInput, "\s{2,}|\n+|<!--(.*?)-->", "", "all" ) );

    cfheader( name="cache-control", value="max-age=604800" );

    if ( cgi.HTTP_ACCEPT_ENCODING contains "gzip" ) {
      var fileOut = createobject( "java", "java.io.ByteArrayOutputStream" ).init( );
      var out = createobject( "java", "java.util.zip.GZIPOutputStream" ).init( fileOut );

      out.write( sInput.getBytes( "UTF-8" ), 0, len( sInput.getBytes( "UTF-8" ) ) );
      out.finish( );
      out.close( );

      cfheader( name="content-encoding", value="gzip" );
      cfheader( name="content-length", value=len( fileout.tobytearray( ) ));
      cfcontent( type="text/html; charset=utf-8", reset=true, variable=fileOut.toByteArray( ));
    } else {
      cfcontent( reset=true );
      writeOutput( sInput );
    }

    abort;
  }

  private struct function parseMarkdownText( required string file ) {
    var result = {
      "title" = "",
      "description" = "",
      "keywords" = "",
      "content" = ""
    };

    if ( structKeyExists( application.cache, "#file#.html" ) ) {
      return application.cache[ "#file#.html" ];
    }

    var inMetaData = true;
    var mdFilePath = this.root & "/texts/#file#.md";
    var mdFileMetaData = [ ];
    var mdFileContent = [ ];

    try {
      var mdFileReader = fileOpen( mdFilePath, "read", "utf-8" );
      while ( !fileIsEOF( mdFileReader ) ) {
        var line = fileReadLine( mdFileReader );
        if ( inMetaData && line == "" ) {
          inMetaData = false;
        }
        arrayAppend( inMetaData ? mdFileMetaData : mdFileContent, line );
      }
      fileClose( mdFileReader );
    } catch ( any e ) {
      return { };
    }

    for ( var kvdata in mdFileMetaData ) {
      var key = trim( listFirst( kvdata, "|" ) );
      var value = trim( listRest( kvdata, "|" ) );
      result[ key ] = value;
    }

    result.content = application.pegDownProcessor.markdownToHtml( trim( arrayToList( mdFileContent, chr( 10 ) ) ) );
    result.content = replace( result.content, '<h1', '<h1 class="row"', 'once' );
    result.content = replace( result.content, '<p', '<p class="lead"', 'all' );
    result.content = replace( result.content, '<table', '<div class="container"><table class="table"', 'all' );
    result.content = replace( result.content, '</table>', '</table></div>', 'all' );

    application.cache[ "#file#.html" ] = result;
    return result;

    return { };
  }

  private void function relocateOnce( ) {
    if ( listFindNoCase( "home,dev", listLast( cgi.server_name, "." ) ) ) {
      return;
    }

    var domainname = "mingo.nl";
    var relocateonce = (
          cgi.server_port_secure == 1
            ? "https"
            : "http"
        ) & "://" & domainname & (
          cgi.script_name == "/index.cfm"
            ? "/"
            : cgi.script_name
        ) & (
          len( trim( cgi.query_string ) ) > 0
            ? "?" & cgi.query_string
            : ""
        );

    if ( cgi.server_name != domainname ) {
      // location( relocateonce, false, 301 );
    }
  }
}

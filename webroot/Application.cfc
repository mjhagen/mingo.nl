component {
  this.name = "mingo-nl";
  tmp = listChangeDelims( getDirectoryFromPath( getCurrentTemplatePath( ) ), '/', '\' );
  this.root = listDeleteAt( tmp, listLen( tmp, "/" ), "/" );
  this.mappings[ "/" ] = this.root;
  this.javaSettings = { loadPaths = [ this.root & "/lib" ] };

  public void function onApplicationStart( ) {
    structClear( application );
    application[ "pegDownProcessor" ] = createObject( "java", "org.pegdown.PegDownProcessor" ).init( javaCast( "int", 32 ) );
    application[ "cache" ] = { };
  }

  public void function onRequestStart( ) {
    if ( !isNull( url.reload ) ) {
      onApplicationStart( );
    }
  }

  public void function onRequest( ) {
    var rc = {
      "title" = "",
      "description" = "",
      "keywords" = "",
      "content" = "",
      "body" = ""
    };

    var pathInfo = cgi.path_info;

    if ( structKeyExists( server, "lucee" ) ) {
      pathInfo = cgi.script_name;
    }

    var tpl = listFirst( listLast( pathInfo, "/" ), "." );

    if ( !len( tpl ) || tpl == "index" ) {
      tpl = "home";
    }

    rc.page = tpl;

//    if ( reFind( "\W+", tpl ) ) {
//      tpl = "404";
//    }

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
    result.content = replace( result.content, '{strava}', fileRead( this.root & '/parts/strava.cfm' ) );

    application.cache[ "#file#.html" ] = result;
    return result;

    return { };
  }
}

<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <title>Storymaps Login</title>
    </head>
    <body>
        <div class="container">

            <div class="well">
                <p>The page you requested requires that you are logged in.  This application uses Google Identity Services for authentication.</p>
                <p>Click the button below to sign in using your Google account.</p>

                <g:link controller="springSecurityOAuth2" action="authenticate" params="[provider: 'google']" style="padding-top:8px;padding-bottom:0;"><asset:image src="btn_google_signin_light_normal_web.png"/></g:link>
            </div>



        </div>
    </body>
</html>
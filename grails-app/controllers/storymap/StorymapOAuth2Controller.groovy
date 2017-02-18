package storymap

import grails.plugin.springsecurity.oauth2.exception.OAuth2Exception
import grails.plugin.springsecurity.oauth2.SpringSecurityOAuth2Controller
import grails.plugin.springsecurity.oauth2.token.OAuth2SpringToken;
import grails.converters.JSON

class StorymapOAuth2Controller extends SpringSecurityOAuth2Controller {

    def googleOAuth2Service

    def login() {
        
    }

    /**
     * From SpringSecurityOAuth2Controller
     */
    def createAccount() {
        OAuth2SpringToken oAuth2SpringToken = session[SPRING_SECURITY_OAUTH_TOKEN] as OAuth2SpringToken
        if (!oAuth2SpringToken) {
            log.warn "createAccount: OAuthToken not found in session"
            throw new OAuth2Exception('Authentication error')
        }
        if (!springSecurityService.loggedIn) {
            def User = springSecurityOauth2BaseService.lookupUserClass()
            boolean created = User.withTransaction { status ->
                def user = springSecurityOauth2BaseService.lookupUserClass().newInstance()

                def googleResource = googleOAuth2Service.getResponse(oAuth2SpringToken.accessToken)
                def googleResponse = JSON.parse(googleResource.getBody())

                //userAccount.firstName = googleResponse.name
                user.username = oAuth2SpringToken.email
                user.password = 'sw!ssCh33se'
                user.enabled = true
                user.addTooAuthIDs(provider: oAuth2SpringToken.providerName, accessToken: oAuth2SpringToken.socialId, user: user)
                if (!user.validate() || !user.save()) {
                    log.debug("UserAccount save failed: " + user.errors)
                    status.setRollbackOnly()
                    false
                } else {
                    def UserRole = springSecurityOauth2BaseService.lookupUserRoleClass()
                    def Role = springSecurityOauth2BaseService.lookupRoleClass()
                    def roles = springSecurityOauth2BaseService.roleNames
                    for (roleName in roles) {
                        log.debug("Creating role " + roleName + " for userAccount " + user.username)
                        // Make sure that the role exists.
                        UserRole.create user, Role.findOrSaveByAuthority(roleName)
                        if (user.username == "neil.ecker@gmail.com") {
                            UserRole.create user, Role.findOrSaveByAuthority("ROLE_ADMIN")
                        }
                    }
                    log.debug("GET AUTHORITIES " + user.getAuthorities())
                    // make sure that the new roles are effective immediately
                    springSecurityService.reauthenticate(user.username)
                    oAuth2SpringToken = springSecurityOauth2BaseService.updateOAuthToken(oAuth2SpringToken, user)
                    true
                }
            }
            if (created) {
                authenticateAndRedirect(oAuth2SpringToken, getDefaultTargetUrl())
                return
            }
        }
        render 'error'
    }

}
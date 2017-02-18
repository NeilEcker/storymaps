package storymap

import grails.gorm.DetachedCriteria
import groovy.transform.ToString

import org.apache.commons.lang.builder.HashCodeBuilder

@ToString(cache=true, includeNames=true, includePackage=false)
class UserRole implements Serializable {

	private static final long serialVersionUID = 1

	UserAccount userAccount
	Role role

	@Override
	boolean equals(other) {
		if (other instanceof UserRole) {
			other.userId == userAccount?.id && other.roleId == role?.id
		}
	}

	@Override
	int hashCode() {
		def builder = new HashCodeBuilder()
		if (userAccount) builder.append(userAccount.id)
		if (role) builder.append(role.id)
		builder.toHashCode()
	}

	static UserRole get(long userId, long roleId) {
		criteriaFor(userId, roleId).get()
	}

	static boolean exists(long userId, long roleId) {
		criteriaFor(userId, roleId).count()
	}

	private static DetachedCriteria criteriaFor(long userId, long roleId) {
		UserRole.where {
			userAccount == UserAccount.load(userId) &&
			role == Role.load(roleId)
		}
	}

	static UserRole create(UserAccount user, Role role) {
		def instance = new UserRole(userAccount: user, role: role)
		instance.save()
		instance
	}

	static boolean remove(UserAccount u, Role r) {
		if (u != null && r != null) {
			UserRole.where { userAccount == u && role == r }.deleteAll()
		}
	}

	static int removeAll(UserAccount u) {
		u == null ? 0 : UserRole.where { userAccount == u }.deleteAll()
	}

	static int removeAll(Role r) {
		r == null ? 0 : UserRole.where { role == r }.deleteAll()
	}

	static constraints = {
		role validator: { Role r, UserRole ur ->
			if (ur.userAccount?.id) {
				UserRole.withNewSession {
					if (UserRole.exists(ur.userAccount.id, r.id)) {
						return ['userRole.exists']
					}
				}
			}
		}
	}

	static mapping = {
		id composite: ['userAccount', 'role']
		version false
	}
}

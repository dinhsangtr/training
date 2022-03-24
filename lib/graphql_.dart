class GraphQL_ {

  static String signIn = """
    mutation login(\$input:LoginCondition!) {
      login(condition: \$input) {
        token
        token_type
        expires_in
        user {
          userId
          vfaEmail
          vfaAvatar
        }
      }
    }""";

  static String userInformation = """
      query userInformation {
        userInformation{
          response {
            userId
            vfaEmail
			      vfaStatus
  		      vfaAvatar
            vfaPhoneWork
            userFullName
            userBirthday
          }
          error {
            requestResolved
            message
            errorCode
          }
        }
      }
    """;

}

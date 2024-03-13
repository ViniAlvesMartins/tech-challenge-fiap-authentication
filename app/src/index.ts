import {
  AuthFlowType,
  paginateListUserPools,
  CognitoIdentityProviderClient,
  InitiateAuthCommand,
} from "@aws-sdk/client-cognito-identity-provider";

export const handler = async (event: any) => {
  const login = event.headers.login;
  const password = event.headers.password;

  const client = new CognitoIdentityProviderClient({});

  const command = new InitiateAuthCommand({
    AuthFlow: AuthFlowType.USER_PASSWORD_AUTH,
    AuthParameters: {
      USERNAME: login,
      PASSWORD: password
    },
    ClientId: 'hk6lfc2knq0q6mnpdoov9hvrk'
  });

  const response = await client.send(command)
  console.log(response)

  return response
}
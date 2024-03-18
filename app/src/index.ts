import {
  AuthFlowType,
  paginateListUserPools,
  CognitoIdentityProviderClient,
  InitiateAuthCommand,
} from "@aws-sdk/client-cognito-identity-provider";

export const handler = async (event: any) => {
  const data = event;

  const client = new CognitoIdentityProviderClient({});

  const command = new InitiateAuthCommand({
    AuthFlow: AuthFlowType.USER_PASSWORD_AUTH,
    AuthParameters: {
      USERNAME: data.login,
      PASSWORD: data.password
    },
    ClientId: '371g5rnln41qgrjfa7qe2qhf2'
  });

  const response = await client.send(command)

  return response
}
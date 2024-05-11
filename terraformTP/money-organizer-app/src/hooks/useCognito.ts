import {AuthenticationDetails, CognitoUserPool, CognitoUser} from 'amazon-cognito-identity-js';
import {useState} from 'react';
import {useAuthStore} from "@/hooks/useAuthStore.ts";
import { useShallow } from 'zustand/react/shallow'

const poolData = {
    UserPoolId: import.meta.env.VITE_USER_POOL as string, // Your user pool id here
    ClientId: import.meta.env.VITE_CLIENT_ID as string // Your client id here
};

const userPool = new CognitoUserPool(poolData);

interface LoginResult {
    idToken: string;
    userEmail: string;
}

export function useLogin(): [(credentials: { email: string, password: string }) => void, LoginResult | undefined, Error | undefined] {
    const [result, setResult] = useState<LoginResult>();
    const [error, setError] = useState<Error>();

    const {setEmail, setIdToken} = useAuthStore(useShallow((state) => ({
        setEmail: state.setEmail,
        setIdToken: state.setIdToken,
    })));

    function login({email, password}: { email: string, password: string }) {
        const cognitoUser = new CognitoUser({
            Username: email,
            Pool: userPool
        });

        const authenticationDetails = new AuthenticationDetails({
            Username: email,
            Password: password
        });

        cognitoUser.authenticateUser(authenticationDetails, {
            onSuccess: function (result) {
                const idToken = result.getIdToken().getJwtToken();
                const userEmail = result.getIdToken().payload.email as unknown as string;

                setEmail(userEmail);
                setIdToken(idToken);

                setResult({idToken, userEmail});
            },

            onFailure: function (err: Error) {
                setError(err);
            },

            newPasswordRequired: function (_, requiredAttributes: string[]) {
                const attributes = [];
                for (const element of requiredAttributes) {
                    attributes.push({
                        Name: element,
                        Value: null
                    });
                }
                cognitoUser.completeNewPasswordChallenge(password, attributes, this);
            }
        });
    }

    return [login, result, error];
}

type registerCredentials = { email: string, password: string};

export function useRegister(): [(credentials: registerCredentials) => void, CognitoUser | undefined, Error | undefined] {
    const [result, setResult] = useState<CognitoUser>();
    const [error, setError] = useState<Error>();

    function register({email, password}: registerCredentials) {

        userPool.signUp(email, password, [], [], (err, result) => {
            if (err) {
                setError(err);
                return;
            }
            if (!result) {
                setError(new Error('No result'));
                return;
            }
            setResult(result.user);
        });
    }

    return [register, result, error];
}
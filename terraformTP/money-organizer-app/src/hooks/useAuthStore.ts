import {create} from "zustand";
import {persist} from "zustand/middleware";

interface AuthStore {
    token: string | null;
    setIdToken: (token: string | null) => void;
    email: string | null;
    setEmail: (loggedUser: string) => void;
}

export const useAuthStore = create<AuthStore>()(
    persist((set) => ({
            token: localStorage.getItem('token') ?? null,
            setIdToken: (token) => {
                set({token});
            },
            email: null,
            setEmail: (email) => set({email}),
        }), {
            name: 'auth-storage',
        }
    )
);
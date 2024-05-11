import { useEffect } from "react";
import { useAuthStore } from "@/hooks/useAuthStore";
import { useNavigate } from "react-router-dom";
import SignUpForm from "@/components/custom/SignUpForm";

export function SignUp() {
  const { token } = useAuthStore();
  const navigate = useNavigate();

  useEffect(() => {
    if (token) {
      navigate("/");
    }
  }, [token, navigate]);

  if (!token) {
    return (
      <>
        <SignUpForm />
      </>
    );
  }

  return null;
}

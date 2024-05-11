import { NavLink } from "react-router-dom";
import { Button } from "../ui/button";
import { useAuthStore } from "@/hooks/useAuthStore";
import { useNavigate } from "react-router-dom";
import { useState, useEffect } from "react";

const Navbar = () => {

  const [currentNav, setCurrentNav] = useState("/my-expenses");
  const navigationRoutes = [
    {
      name: "My expenses",
      path: "/my-expenses",
    },
    {
      name: "My budgets",
      path: "/my-budgets",
    },
  ];

  const { setIdToken } = useAuthStore();

  const navigate = useNavigate();

  const handleLogout = () => {
    setIdToken(null);

    navigate("/login");
  };

  const handleSelectNav = (routePath: string) => {
    setCurrentNav(routePath)
  }

  useEffect(() => {
    // Set the initial state based on the current route
    setCurrentNav(window.location.pathname);
  }, []);

  return (
    <>
      <div>
        <ul className={"items-center flex justify-between p-3 border-b-2"}>
          {navigationRoutes.map((route, index) => (
            <li key={index}
            onClick={() => handleSelectNav(route.path)}>
              <NavLink
              to={route.path}
              className={currentNav == route.path? "font-bold": ""}
              >{route.name}</NavLink>
            </li>
          ))}
          <li key="Log out">
            <Button onClick={handleLogout}>Log out</Button>
          </li>
        </ul>
      </div>
    </>
  );
};

export default Navbar;

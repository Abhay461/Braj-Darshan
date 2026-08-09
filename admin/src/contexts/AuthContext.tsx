import React, { createContext, useContext, useState, useEffect } from 'react';

interface AuthContextType {
  isAuthenticated: boolean;
  login: (pin: string) => boolean;
  logout: () => void;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

const ADMIN_PIN_KEY = 'braj_darshan_admin_session';

export const AuthProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const SESSION_TIMEOUT_MS = 30 * 60 * 1000; // 30 minutes

  const [isAuthenticated, setIsAuthenticated] = useState<boolean>(() => {
    const stored = localStorage.getItem(ADMIN_PIN_KEY);
    const expiryStr = localStorage.getItem(`${ADMIN_PIN_KEY}_expiry`);
    if (stored === 'true' && expiryStr) {
      const expiry = parseInt(expiryStr, 10);
      if (Date.now() < expiry) {
        return true;
      } else {
        // session expired
        localStorage.removeItem(ADMIN_PIN_KEY);
        localStorage.removeItem(`${ADMIN_PIN_KEY}_expiry`);
      }
    }
    return false;
  });

  const [sessionExpiry, setSessionExpiry] = useState<number>(() => {
    const expiryStr = localStorage.getItem(`${ADMIN_PIN_KEY}_expiry`);
    return expiryStr ? parseInt(expiryStr, 10) : 0;
  });

  useEffect(() => {
    if (!isAuthenticated) return;
    const interval = setInterval(() => {
      if (Date.now() > sessionExpiry) {
        logout();
      }
    }, 60 * 1000); // check every minute
    return () => clearInterval(interval);
  }, [isAuthenticated, sessionExpiry]);

  const login = (pin: string): boolean => {
    // Standard default Admin PIN: 123456 or 108108
    if (pin === '123456' || pin === '108108' || pin === 'admin') {
      const expiry = Date.now() + SESSION_TIMEOUT_MS;
      localStorage.setItem(ADMIN_PIN_KEY, 'true');
      localStorage.setItem(`${ADMIN_PIN_KEY}_expiry`, expiry.toString());
      setIsAuthenticated(true);
      setSessionExpiry(expiry);
      return true;
    }
    return false;
  };

  const logout = () => {
    localStorage.removeItem(ADMIN_PIN_KEY);
    localStorage.removeItem(`${ADMIN_PIN_KEY}_expiry`);
    setIsAuthenticated(false);
    setSessionExpiry(0);
  };

  return (
    <AuthContext.Provider value={{ isAuthenticated, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};

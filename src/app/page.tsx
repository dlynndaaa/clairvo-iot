'use client';

import { useState } from 'react';
import LandingPage from '@/components/LandingPage';
import LoginPage from '@/components/LoginPage';
import Dashboard from '@/components/Dashboard';

export default function Home() {
  const [currentPage, setCurrentPage] = useState('landing'); // 'landing', 'login', 'dashboard'
  const [user, setUser] = useState(null);

  const handleLoginSuccess = (userData: any) => {
    setUser(userData);
    setCurrentPage('dashboard');
  };

  const handleLogout = () => {
    setUser(null);
    setCurrentPage('landing');
  };

  return (
    <>
      {currentPage === 'landing' && (
        <LandingPage onLoginClick={() => setCurrentPage('login')} />
      )}
      {currentPage === 'login' && (
        <LoginPage
          onLoginSuccess={handleLoginSuccess}
          onBackClick={() => setCurrentPage('landing')}
        />
      )}
      {currentPage === 'dashboard' && (
        <Dashboard user={user} onLogout={handleLogout} />
      )}
    </>
  );
}

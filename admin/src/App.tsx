import React from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { ThemeProvider, CssBaseline } from '@mui/material';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { SnackbarProvider } from 'notistack';

import { theme } from './theme/theme';
import { AuthProvider, useAuth } from './contexts/AuthContext';
import { ErrorBoundary } from './components/common/ErrorBoundary';
import { DashboardLayout } from './layouts/DashboardLayout';

import { Login } from './pages/Login';
import { Dashboard } from './pages/Dashboard';
import { TempleList } from './pages/temples/TempleList';
import { TempleForm } from './pages/temples/TempleForm';
import { CategoryList } from './pages/categories/CategoryList';
import { LocationList } from './pages/locations/LocationList';
import { FacilityList } from './pages/facilities/FacilityList';
import { FestivalList } from './pages/festivals/FestivalList';
import { MediaLibrary } from './pages/media/MediaLibrary';
import { BackupImportExport } from './pages/backup/BackupImportExport';

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 1000 * 60 * 5, // 5 minutes cache
      refetchOnWindowFocus: false,
      retry: 1,
    },
  },
});

const ProtectedRoute: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const { isAuthenticated } = useAuth();
  if (!isAuthenticated) {
    return <Navigate to="/login" replace />;
  }
  return <>{children}</>;
};

export const App: React.FC = () => {
  return (
    <ErrorBoundary>
      <QueryClientProvider client={queryClient}>
        <ThemeProvider theme={theme}>
          <CssBaseline />
          <SnackbarProvider maxSnack={4} anchorOrigin={{ vertical: 'bottom', horizontal: 'right' }}>
            <AuthProvider>
              <BrowserRouter>
                <Routes>
                  <Route path="/login" element={<Login />} />

                  <Route
                    path="/"
                    element={
                      <ProtectedRoute>
                        <DashboardLayout />
                      </ProtectedRoute>
                    }
                  >
                    <Route index element={<Dashboard />} />
                    <Route path="temples" element={<TempleList />} />
                    <Route path="temples/new" element={<TempleForm />} />
                    <Route path="temples/:id/edit" element={<TempleForm />} />
                    <Route path="categories" element={<CategoryList />} />
                    <Route path="locations" element={<LocationList />} />
                    <Route path="facilities" element={<FacilityList />} />
                    <Route path="festivals" element={<FestivalList />} />
                    <Route path="media" element={<MediaLibrary />} />
                    <Route path="backup" element={<BackupImportExport />} />
                  </Route>

                  <Route path="*" element={<Navigate to="/" replace />} />
                </Routes>
              </BrowserRouter>
            </AuthProvider>
          </SnackbarProvider>
        </ThemeProvider>
      </QueryClientProvider>
    </ErrorBoundary>
  );
};

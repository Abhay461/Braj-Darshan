import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Box, Card, CardContent, Typography, TextField, Button, Alert } from '@mui/material';
import LockOutlinedIcon from '@mui/icons-material/LockOutlined';
import { useAuth } from '../contexts/AuthContext';

export const Login: React.FC = () => {
  const [pin, setPin] = useState('');
  const [error, setError] = useState('');
  const { login } = useAuth();
  const navigate = useNavigate();

  const handleLogin = (e: React.FormEvent) => {
    e.preventDefault();
    if (!pin) {
      setError('Please enter Admin PIN');
      return;
    }

    const success = login(pin);
    if (success) {
      navigate('/');
    } else {
      setError('Invalid Admin PIN. (Default: 123456)');
    }
  };

  return (
    <Box
      sx={{
        minHeight: '100vh',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        backgroundColor: '#FAF9F6',
        p: 2,
      }}
    >
      <Card sx={{ maxWidth: 400, width: '100%', borderRadius: '20px', p: 1.5, border: '1px solid #E4E4E7' }}>
        <CardContent sx={{ p: 3, textAlign: 'center' }}>
          <Box
            sx={{
              width: 54,
              height: 54,
              borderRadius: '16px',
              backgroundColor: '#18181B',
              color: '#FFFFFF',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              mx: 'auto',
              mb: 2,
            }}
          >
            <LockOutlinedIcon sx={{ fontSize: 28 }} />
          </Box>
          <Typography variant="h2" sx={{ fontSize: '1.5rem', fontWeight: 700, mb: 0.5 }}>
            Braj Darshan CMS
          </Typography>
          <Typography variant="body2" color="text.secondary" sx={{ mb: 3 }}>
            Enter Admin PIN to access platform dashboard
          </Typography>

          {error && (
            <Alert severity="error" sx={{ mb: 2, borderRadius: '12px', fontSize: '0.8125rem' }}>
              {error}
            </Alert>
          )}

          <form onSubmit={handleLogin}>
            <TextField
              fullWidth
              type="password"
              label="Admin PIN"
              placeholder="Enter PIN (e.g. 123456)"
              value={pin}
              onChange={(e) => {
                setPin(e.target.value);
                setError('');
              }}
              sx={{ mb: 3 }}
              autoFocus
            />
            <Button fullWidth size="large" type="submit" variant="contained" sx={{ py: 1.5 }}>
              Sign In to Admin Panel
            </Button>
          </form>
        </CardContent>
      </Card>
    </Box>
  );
};

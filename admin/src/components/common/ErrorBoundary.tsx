import React, { Component, ErrorInfo, ReactNode } from 'react';
import { Box, Typography, Button, Paper } from '@mui/material';
import AlertCircle from '@mui/icons-material/ErrorOutline';

interface Props {
  children: ReactNode;
}

interface State {
  hasError: boolean;
  error?: Error;
}

export class ErrorBoundary extends Component<Props, State> {
  public state: State = {
    hasError: false,
  };

  public static getDerivedStateFromError(error: Error): State {
    return { hasError: true, error };
  }

  public componentDidCatch(error: Error, errorInfo: ErrorInfo) {
    console.error('Uncaught error:', error, errorInfo);
  }

  public render() {
    if (this.state.hasError) {
      return (
        <Box sx={{ p: 4, display: 'flex', justifyContent: 'center', alignItems: 'center', minHeight: 400 }}>
          <Paper sx={{ p: 4, textAlign: 'center', maxWidth: 500, borderRadius: '18px' }}>
            <AlertCircle sx={{ fontSize: 48, color: '#18181B', mb: 2 }} />
            <Typography variant="h3" sx={{ mb: 1 }}>
              Something went wrong
            </Typography>
            <Typography variant="body2" color="text.secondary" sx={{ mb: 3 }}>
              {this.state.error?.message || 'An unexpected application error occurred.'}
            </Typography>
            <Button
              variant="contained"
              onClick={() => {
                this.setState({ hasError: false });
                window.location.reload();
              }}
            >
              Retry / Reload Application
            </Button>
          </Paper>
        </Box>
      );
    }

    return this.props.children;
  }
}

import { createTheme } from '@mui/material/styles';

export const theme = createTheme({
  palette: {
    mode: 'light',
    primary: {
      main: '#18181B', // Deep Charcoal / Black
      light: '#27272A',
      dark: '#09090B',
      contrastText: '#FFFFFF',
    },
    secondary: {
      main: '#71717A', // Muted Neutral Gray
      light: '#A1A1AA',
      dark: '#52525B',
      contrastText: '#FFFFFF',
    },
    background: {
      default: '#FAF9F6', // Minimal Canvas
      paper: '#FFFFFF',   // Surface Card
    },
    text: {
      primary: '#09090B',
      secondary: '#71717A',
      disabled: '#A1A1AA',
    },
    divider: '#E4E4E7',
    success: {
      main: '#16A34A',
    },
    error: {
      main: '#DC2626',
    },
    warning: {
      main: '#52525B', // Clean neutral warning fallback
    },
    info: {
      main: '#2563EB',
    },
  },
  typography: {
    fontFamily: '"Inter", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif',
    h1: { fontSize: '2.25rem', fontWeight: 700, letterSpacing: '-0.02em', color: '#09090B' },
    h2: { fontSize: '1.75rem', fontWeight: 700, letterSpacing: '-0.015em', color: '#09090B' },
    h3: { fontSize: '1.375rem', fontWeight: 600, letterSpacing: '-0.01em', color: '#09090B' },
    h4: { fontSize: '1.125rem', fontWeight: 600, color: '#09090B' },
    h5: { fontSize: '1rem', fontWeight: 600, color: '#09090B' },
    h6: { fontSize: '0.875rem', fontWeight: 600, color: '#09090B' },
    subtitle1: { fontSize: '0.875rem', color: '#71717A' },
    subtitle2: { fontSize: '0.75rem', fontWeight: 500, color: '#71717A' },
    body1: { fontSize: '0.875rem', color: '#09090B', lineHeight: 1.5 },
    body2: { fontSize: '0.8125rem', color: '#71717A', lineHeight: 1.4 },
    button: { textTransform: 'none', fontWeight: 600, fontSize: '0.875rem' },
  },
  shape: {
    borderRadius: 18, // 18px Border Radius per specification
  },
  components: {
    MuiCssBaseline: {
      styleOverrides: {
        body: {
          backgroundColor: '#FAF9F6',
          color: '#09090B',
          fontFamily: '"Inter", sans-serif',
        },
      },
    },
    MuiPaper: {
      styleOverrides: {
        root: {
          borderRadius: 18,
          boxShadow: '0 2px 12px rgba(0, 0, 0, 0.03), 0 1px 3px rgba(0, 0, 0, 0.02)',
          border: '1px solid #E4E4E7',
          backgroundImage: 'none',
        },
      },
    },
    MuiButton: {
      styleOverrides: {
        root: {
          borderRadius: 14,
          padding: '8px 18px',
          boxShadow: 'none',
          '&:hover': {
            boxShadow: 'none',
          },
        },
        containedPrimary: {
          backgroundColor: '#18181B',
          color: '#FFFFFF',
          '&:hover': {
            backgroundColor: '#27272A',
          },
        },
        outlinedPrimary: {
          borderColor: '#E4E4E7',
          color: '#18181B',
          '&:hover': {
            borderColor: '#18181B',
            backgroundColor: '#F4F4F5',
          },
        },
      },
    },
    MuiCard: {
      styleOverrides: {
        root: {
          borderRadius: 18,
          border: '1px solid #E4E4E7',
          boxShadow: '0 2px 12px rgba(0, 0, 0, 0.03)',
        },
      },
    },
    MuiTextField: {
      defaultProps: {
        variant: 'outlined',
        size: 'medium',
      },
    },
    MuiOutlinedInput: {
      styleOverrides: {
        root: {
          borderRadius: 14,
          backgroundColor: '#FFFFFF',
          '& fieldset': {
            borderColor: '#E4E4E7',
          },
          '&:hover fieldset': {
            borderColor: '#A1A1AA',
          },
          '&.Mui-focused fieldset': {
            borderColor: '#18181B',
            borderWidth: '1.5px',
          },
        },
      },
    },
    MuiChip: {
      styleOverrides: {
        root: {
          borderRadius: 10,
          fontWeight: 500,
        },
      },
    },
    MuiTableCell: {
      styleOverrides: {
        head: {
          fontWeight: 600,
          backgroundColor: '#FAFAFA',
          color: '#52525B',
          borderBottom: '1px solid #E4E4E7',
        },
        body: {
          borderBottom: '1px solid #F4F4F5',
          fontSize: '0.875rem',
        },
      },
    },
  },
});

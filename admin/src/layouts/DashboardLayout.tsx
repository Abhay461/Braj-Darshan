import React, { useState } from 'react';
import { Outlet, useNavigate, useLocation, Link as RouterLink } from 'react-router-dom';
import {
  Box,
  Drawer,
  AppBar,
  Toolbar,
  Typography,
  List,
  ListItem,
  ListItemButton,
  ListItemIcon,
  ListItemText,
  IconButton,
  Chip,
  Menu,
  MenuItem,
} from '@mui/material';
import MenuIcon from '@mui/icons-material/Menu';
import DashboardIcon from '@mui/icons-material/DashboardOutlined';
import TempleIcon from '@mui/icons-material/AccountBalanceOutlined';
import CategoryIcon from '@mui/icons-material/CategoryOutlined';
import LocationIcon from '@mui/icons-material/LocationOnOutlined';
import FacilityIcon from '@mui/icons-material/HomeRepairServiceOutlined';
import FestivalIcon from '@mui/icons-material/EventOutlined';
import MediaIcon from '@mui/icons-material/PermMediaOutlined';
import BackupIcon from '@mui/icons-material/BackupOutlined';
import LogoutIcon from '@mui/icons-material/LogoutOutlined';
import AccountCircleIcon from '@mui/icons-material/AccountCircleOutlined';
import CheckCircleIcon from '@mui/icons-material/CheckCircle';
import WarningIcon from '@mui/icons-material/WarningAmberOutlined';
import MapIcon from '@mui/icons-material/MapOutlined';
import ShieldIcon from '@mui/icons-material/ShieldOutlined';
import { useAuth } from '../contexts/AuthContext';
import { useHealth } from '../hooks/useHealth';

const DRAWER_WIDTH = 260;

const navItems = [
  { label: 'Dashboard', path: '/', icon: <DashboardIcon /> },
  { label: 'Temples', path: '/temples', icon: <TempleIcon /> },
  { label: 'Categories', path: '/categories', icon: <CategoryIcon /> },
  { label: 'Locations', path: '/locations', icon: <LocationIcon /> },
  { label: 'Map Settings', path: '/map-settings', icon: <MapIcon /> },
  { label: 'Festivals', path: '/festivals', icon: <FestivalIcon /> },
  { label: 'Emergency Contacts', path: '/emergency-contacts', icon: <ShieldIcon /> },
  { label: 'Media Library', path: '/media', icon: <MediaIcon /> },
  { label: 'Backup & Import', path: '/backup', icon: <BackupIcon /> },
];

export const DashboardLayout: React.FC = () => {
  const [mobileOpen, setMobileOpen] = useState(false);
  const [anchorEl, setAnchorEl] = useState<null | HTMLElement>(null);
  const { logout } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();
  const { data: healthRes } = useHealth();

  const isHealthy = healthRes?.data?.status === 'ok' && healthRes?.data?.database === 'connected';

  const handleDrawerToggle = () => {
    setMobileOpen(!mobileOpen);
  };

  const handleMenuOpen = (event: React.MouseEvent<HTMLElement>) => {
    setAnchorEl(event.currentTarget);
  };

  const handleMenuClose = () => {
    setAnchorEl(null);
  };

  const handleLogout = () => {
    handleMenuClose();
    logout();
    navigate('/login');
  };

  const drawerContent = (
    <Box sx={{ height: '100%', display: 'flex', flexDirection: 'column', backgroundColor: '#FFFFFF' }}>
      {/* Brand Header */}
      <Box sx={{ p: 3, display: 'flex', alignItems: 'center', gap: 1.5, borderBottom: '1px solid #E4E4E7' }}>
        <Box
          sx={{
            width: 38,
            height: 38,
            borderRadius: '12px',
            backgroundColor: '#18181B',
            color: '#FFFFFF',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            fontWeight: 800,
            fontSize: '1.125rem',
          }}
        >
          B
        </Box>
        <Box>
          <Typography variant="h6" sx={{ fontWeight: 700, lineHeight: 1.2 }}>
            Braj Darshan
          </Typography>
          <Typography variant="caption" color="text.secondary" sx={{ fontWeight: 500 }}>
            CMS Admin v1.0
          </Typography>
        </Box>
      </Box>

      {/* Navigation List */}
      <List sx={{ px: 2, py: 2, flexGrow: 1 }}>
        {navItems.map((item) => {
          const active = location.pathname === item.path || (item.path !== '/' && location.pathname.startsWith(item.path));
          return (
            <ListItem key={item.path} disablePadding sx={{ mb: 0.5 }}>
              <ListItemButton
                component={RouterLink}
                to={item.path}
                selected={active}
                sx={{
                  borderRadius: '12px',
                  py: 1.2,
                  px: 2,
                  color: active ? '#18181B' : '#71717A',
                  backgroundColor: active ? '#F4F4F5 !important' : 'transparent',
                  fontWeight: active ? 600 : 500,
                  '&:hover': {
                    backgroundColor: '#FAFAFA',
                    color: '#18181B',
                  },
                }}
              >
                <ListItemIcon
                  sx={{
                    minWidth: 36,
                    color: active ? '#18181B' : '#71717A',
                  }}
                >
                  {item.icon}
                </ListItemIcon>
                <ListItemText
                  primary={item.label}
                  primaryTypographyProps={{
                    fontSize: '0.875rem',
                    fontWeight: active ? 600 : 500,
                  }}
                />
              </ListItemButton>
            </ListItem>
          );
        })}
      </List>

      {/* System Status Footer */}
      <Box sx={{ p: 2.5, borderTop: '1px solid #E4E4E7', backgroundColor: '#FAFAFA' }}>
        <Typography variant="caption" color="text.secondary" sx={{ display: 'block', mb: 1, fontWeight: 600 }}>
          API Connection
        </Typography>
        <Chip
          icon={isHealthy ? <CheckCircleIcon style={{ color: '#16A34A' }} /> : <WarningIcon style={{ color: '#DC2626' }} />}
          label={isHealthy ? 'Backend Connected' : 'Disconnected'}
          size="small"
          variant="outlined"
          sx={{
            borderColor: '#E4E4E7',
            backgroundColor: '#FFFFFF',
            fontWeight: 600,
            fontSize: '0.75rem',
            width: '100%',
            justifyContent: 'flex-start',
          }}
        />
      </Box>
    </Box>
  );

  return (
    <Box sx={{ display: 'flex', minHeight: '100vh', backgroundColor: '#FAF9F6' }}>
      {/* AppBar / Sticky Topbar */}
      <AppBar
        position="fixed"
        elevation={0}
        sx={{
          width: { sm: \calc(100% - \px)\ },
          ml: { sm: \\px\ },
          backgroundColor: 'rgba(255, 255, 255, 0.85)',
          backdropFilter: 'blur(8px)',
          borderBottom: '1px solid #E4E4E7',
          color: '#18181B',
        }}
      >
        <Toolbar sx={{ justifyContent: 'space-between' }}>
          <Box sx={{ display: 'flex', alignItems: 'center' }}>
            <IconButton
              color="inherit"
              edge="start"
              onClick={handleDrawerToggle}
              sx={{ mr: 2, display: { sm: 'none' } }}
            >
              <MenuIcon />
            </IconButton>
            <Typography variant="body1" sx={{ fontWeight: 600, color: '#18181B' }}>
              Braj Darshan Platform Management
            </Typography>
          </Box>

          <Box sx={{ display: 'flex', alignItems: 'center', gap: 1.5 }}>
            <Chip
              label="Phase 1 Ready"
              size="small"
              sx={{ backgroundColor: '#F4F4F5', color: '#18181B', fontWeight: 600 }}
            />
            <IconButton onClick={handleMenuOpen} size="small">
              <AccountCircleIcon sx={{ fontSize: 32, color: '#18181B' }} />
            </IconButton>
            <Menu
              anchorEl={anchorEl}
              open={Boolean(anchorEl)}
              onClose={handleMenuClose}
              PaperProps={{ sx: { borderRadius: '14px', mt: 1, minWidth: 160 } }}
            >
              <MenuItem onClick={handleLogout} sx={{ color: '#DC2626', fontWeight: 500 }}>
                <LogoutIcon sx={{ mr: 1.5, fontSize: 18 }} />
                Sign Out
              </MenuItem>
            </Menu>
          </Box>
        </Toolbar>
      </AppBar>

      {/* Sidebar Navigation Drawer */}
      <Box component="nav" sx={{ width: { sm: DRAWER_WIDTH }, flexShrink: { sm: 0 } }}>
        <Drawer
          variant="temporary"
          open={mobileOpen}
          onClose={handleDrawerToggle}
          ModalProps={{ keepMounted: true }}
          sx={{
            display: { xs: 'block', sm: 'none' },
            '& .MuiDrawer-paper': { boxSizing: 'border-box', width: DRAWER_WIDTH },
          }}
        >
          {drawerContent}
        </Drawer>

        <Drawer
          variant="permanent"
          sx={{
            display: { xs: 'none', sm: 'block' },
            '& .MuiDrawer-paper': { boxSizing: 'border-box', width: DRAWER_WIDTH, borderRight: '1px solid #E4E4E7' },
          }}
          open
        >
          {drawerContent}
        </Drawer>
      </Box>

      {/* Main Content Area */}
      <Box
        component="main"
        sx={{
          flexGrow: 1,
          p: { xs: 2.5, sm: 4 },
          width: { sm: \calc(100% - \px)\ },
          mt: 8,
        }}
      >
        <Outlet />
      </Box>
    </Box>
  );
};

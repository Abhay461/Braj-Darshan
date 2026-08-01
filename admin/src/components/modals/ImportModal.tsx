import React, { useState } from 'react';
import {
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Button,
  Box,
  Typography,
  Table,
  TableHead,
  TableRow,
  TableCell,
  TableBody,
  CircularProgress,
} from '@mui/material';
import CloudUploadIcon from '@mui/icons-material/CloudUploadOutlined';
import { Temple } from '../../types';
import { parseCsvTemples } from '../../utils/csvHelper';
import { useSnackbar } from 'notistack';

interface ImportModalProps {
  open: boolean;
  onClose: () => void;
  onImport: (temples: Partial<Temple>[]) => Promise<void>;
}

export const ImportModal: React.FC<ImportModalProps> = ({ open, onClose, onImport }) => {
  const [parsedTemples, setParsedTemples] = useState<Partial<Temple>[]>([]);
  const [filename, setFilename] = useState<string>('');
  const [loading, setLoading] = useState(false);
  const { enqueueSnackbar } = useSnackbar();

  const handleFileUpload = (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    if (!file) return;

    setFilename(file.name);
    const reader = new FileReader();

    reader.onload = (e) => {
      const content = e.target?.result as string;
      if (file.name.endsWith('.json')) {
        try {
          const json = JSON.parse(content);
          const list = Array.isArray(json) ? json : json.temples || [json];
          setParsedTemples(list);
        } catch {
          enqueueSnackbar('Invalid JSON file format', { variant: 'error' });
        }
      } else if (file.name.endsWith('.csv')) {
        const list = parseCsvTemples(content);
        setParsedTemples(list);
      }
    };

    reader.readAsText(file);
  };

  const handleConfirmImport = async () => {
    if (parsedTemples.length === 0) return;
    try {
      setLoading(true);
      await onImport(parsedTemples);
      enqueueSnackbar(`Successfully imported ${parsedTemples.length} temple(s)`, { variant: 'success' });
      onClose();
    } catch {
      enqueueSnackbar('Bulk import failed', { variant: 'error' });
    } finally {
      setLoading(false);
    }
  };

  return (
    <Dialog open={open} onClose={onClose} maxWidth="md" fullWidth PaperProps={{ sx: { borderRadius: '18px', p: 1 } }}>
      <DialogTitle sx={{ fontWeight: 700 }}>Bulk Import Temples (CSV / JSON)</DialogTitle>
      <DialogContent>
        <Box sx={{ p: 3, border: '2px dashed #E4E4E7', borderRadius: '14px', textAlign: 'center', mb: 3 }}>
          <Button component="label" variant="contained" startIcon={<CloudUploadIcon />}>
            Select CSV or JSON File
            <input type="file" hidden accept=".csv,.json" onChange={handleFileUpload} />
          </Button>
          {filename && (
            <Typography variant="body2" sx={{ mt: 1, fontWeight: 600 }}>
              Loaded File: {filename} ({parsedTemples.length} records found)
            </Typography>
          )}
        </Box>

        {parsedTemples.length > 0 && (
          <Box sx={{ maxHeight: 300, overflowY: 'auto' }}>
            <Typography variant="subtitle2" sx={{ mb: 1, fontWeight: 600 }}>
              Import Preview ({parsedTemples.length} items)
            </Typography>
            <Table size="small">
              <TableHead>
                <TableRow>
                  <TableCell>Name</TableCell>
                  <TableCell>Short Description</TableCell>
                  <TableCell>Lat / Lng</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {parsedTemples.slice(0, 5).map((temple, idx) => (
                  <TableRow key={idx}>
                    <TableCell sx={{ fontWeight: 600 }}>{temple.name}</TableCell>
                    <TableCell sx={{ maxWidth: 300, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                      {temple.shortDescription}
                    </TableCell>
                    <TableCell>{`${temple.latitude}, ${temple.longitude}`}</TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
            {parsedTemples.length > 5 && (
              <Typography variant="caption" color="text.secondary" sx={{ mt: 1, display: 'block' }}>
                + {parsedTemples.length - 5} more records ready for import...
              </Typography>
            )}
          </Box>
        )}
      </DialogContent>
      <DialogActions sx={{ px: 3, pb: 2 }}>
        <Button onClick={onClose} disabled={loading} variant="outlined" color="inherit">
          Cancel
        </Button>
        <Button
          onClick={handleConfirmImport}
          disabled={loading || parsedTemples.length === 0}
          variant="contained"
        >
          {loading ? <CircularProgress size={20} color="inherit" /> : `Import ${parsedTemples.length} Records`}
        </Button>
      </DialogActions>
    </Dialog>
  );
};

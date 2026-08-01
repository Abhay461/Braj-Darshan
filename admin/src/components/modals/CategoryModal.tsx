import React, { useEffect } from 'react';
import { useForm, Controller } from 'react-hook-form';
import { z } from 'zod';
import { zodResolver } from '@hookform/resolvers/zod';
import {
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Button,
  TextField,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  Grid2 as Grid,
} from '@mui/material';
import { Category } from '../../types';

const categorySchema = z.object({
  name: z.string().min(1, 'Category name is required').max(100),
  description: z.string().optional(),
  icon: z.string().optional(),
  sortOrder: z.coerce.number().optional().default(0),
  status: z.enum(['active', 'inactive']).default('active'),
});

type CategoryFormData = z.infer<typeof categorySchema>;

interface CategoryModalProps {
  open: boolean;
  category: Category | null;
  loading?: boolean;
  onClose: () => void;
  onSubmit: (data: CategoryFormData) => Promise<void>;
}

export const CategoryModal: React.FC<CategoryModalProps> = ({
  open,
  category,
  loading = false,
  onClose,
  onSubmit,
}) => {
  const {
    control,
    handleSubmit,
    reset,
    formState: { errors },
  } = useForm<CategoryFormData>({
    resolver: zodResolver(categorySchema),
    defaultValues: {
      name: '',
      description: '',
      icon: 'temple_hindu',
      sortOrder: 0,
      status: 'active',
    },
  });

  useEffect(() => {
    if (category) {
      reset({
        name: category.name || '',
        description: category.description || '',
        icon: category.icon || 'temple_hindu',
        sortOrder: category.sortOrder || 0,
        status: category.status || 'active',
      });
    } else {
      reset({
        name: '',
        description: '',
        icon: 'temple_hindu',
        sortOrder: 0,
        status: 'active',
      });
    }
  }, [category, reset, open]);

  const handleFormSubmit = async (data: CategoryFormData) => {
    await onSubmit(data);
    onClose();
  };

  return (
    <Dialog open={open} onClose={onClose} maxWidth="sm" fullWidth PaperProps={{ sx: { borderRadius: '18px', p: 1 } }}>
      <DialogTitle sx={{ fontWeight: 700 }}>
        {category ? 'Edit Category' : 'Create New Category'}
      </DialogTitle>
      <form onSubmit={handleSubmit(handleFormSubmit)}>
        <DialogContent>
          <Grid container spacing={2}>
            <Grid size={{ xs: 12 }}>
              <Controller
                name="name"
                control={control}
                render={({ field }) => (
                  <TextField
                    {...field}
                    label="Category Name *"
                    fullWidth
                    error={!!errors.name}
                    helperText={errors.name?.message}
                  />
                )}
              />
            </Grid>

            <Grid size={{ xs: 12 }}>
              <Controller
                name="description"
                control={control}
                render={({ field }) => (
                  <TextField {...field} label="Description" fullWidth multiline rows={3} />
                )}
              />
            </Grid>

            <Grid size={{ xs: 12, sm: 6 }}>
              <Controller
                name="icon"
                control={control}
                render={({ field }) => (
                  <TextField {...field} label="Material Icon Code" fullWidth placeholder="temple_hindu" />
                )}
              />
            </Grid>

            <Grid size={{ xs: 12, sm: 6 }}>
              <Controller
                name="sortOrder"
                control={control}
                render={({ field }) => (
                  <TextField {...field} type="number" label="Sort Order" fullWidth />
                )}
              />
            </Grid>

            <Grid size={{ xs: 12 }}>
              <Controller
                name="status"
                control={control}
                render={({ field }) => (
                  <FormControl fullWidth size="medium">
                    <InputLabel>Status</InputLabel>
                    <Select {...field} label="Status">
                      <MenuItem value="active">Active</MenuItem>
                      <MenuItem value="inactive">Inactive</MenuItem>
                    </Select>
                  </FormControl>
                )}
              />
            </Grid>
          </Grid>
        </DialogContent>
        <DialogActions sx={{ px: 3, pb: 2 }}>
          <Button onClick={onClose} disabled={loading} variant="outlined" color="inherit">
            Cancel
          </Button>
          <Button type="submit" disabled={loading} variant="contained">
            {loading ? 'Saving...' : category ? 'Update Category' : 'Create Category'}
          </Button>
        </DialogActions>
      </form>
    </Dialog>
  );
};

import { useQuery } from '@tanstack/react-query';
import { healthApi } from '../api/healthApi';

export const useHealth = () => {
  return useQuery({
    queryKey: ['health'],
    queryFn: () => healthApi.getHealth(),
    refetchInterval: 30000, // Check backend health every 30 seconds
  });
};

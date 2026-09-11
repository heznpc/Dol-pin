import { QueryClient, type DehydratedState } from '@tanstack/react-query';
import { hydrateRoot } from 'react-dom/client';
import { AppRoot } from './App';

const queryClient = new QueryClient({
  defaultOptions: {
    queries: { staleTime: 30_000, retry: false },
  },
});

const stateElement = document.getElementById('__TANSTACK_STATE__');
const dehydratedState = stateElement?.textContent
  ? (JSON.parse(stateElement.textContent) as DehydratedState)
  : ({ mutations: [], queries: [] } as DehydratedState);

hydrateRoot(
  document.getElementById('root')!,
  <AppRoot
    queryClient={queryClient}
    dehydratedState={dehydratedState}
    url={`${window.location.pathname}${window.location.search}`}
  />,
);

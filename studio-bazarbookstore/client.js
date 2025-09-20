import {createClient} from '@sanity/client'

const client = createClient({
  projectId: 'exvg489e', // your projectId
  dataset: 'production', // your dataset
  token: 'YOUR_SANITY_WRITE_TOKEN', // must have write permissions
  useCdn: false,
  apiVersion: '2023-05-03',
})

export default client

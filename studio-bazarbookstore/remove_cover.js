import {createClient} from '@sanity/client'

const client = createClient({
  projectId: 'exvg489e',
  dataset: 'production',
  token:
    'YOUR_SANITY_WRITE_TOKENskh4MQMbahumc49whAAFwnOWOPt1iF4laKYYAL0wKELELsLV8Si7FWSQP0kExVWenuhh11sukI7AQgsCXHuNsrIgoy7N2Q13VlXRUFBevSZ6sJIjdTblt8hJmKn99dCzOZcFdBfU2dYbXQp0RVAioUlqUwj9su2kRYmeS73eKdOfdi5FVfbg', // must have write permissions
  useCdn: false,
  apiVersion: '2023-05-03',
})

async function deleteAllBooks() {
  const books = await client.fetch('*[_type == "book"]{_id}')

  for (const book of books) {
    await client.delete(book._id)
  }
}

deleteAllBooks()

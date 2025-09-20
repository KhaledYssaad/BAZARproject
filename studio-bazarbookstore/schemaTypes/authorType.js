import {defineField, defineType} from 'sanity'

export const authorType = defineType({
  name: 'author',
  title: 'Author',
  type: 'document',
  fields: [
    defineField({
      name: 'name',
      title: 'Name',
      type: 'string',
      validation: (rule) => rule.required().min(1).max(100),
    }),
    defineField({
      name: 'topWork',
      title: 'Top Work',
      type: 'string',
      description: "The author's most famous work",
      validation: (rule) => rule.required(),
    }),
    defineField({
      name: 'birthDate',
      title: 'Birth Date',
      type: 'string',
      description: 'Format: YYYY-MM-DD',
    }),
    defineField({
      name: 'deathDate',
      title: 'Death Date',
      type: 'string',
      description: 'Format: YYYY-MM-DD, if applicable',
    }),
    defineField({
      name: 'bio',
      title: 'Biography',
      type: 'text',
    }),
    defineField({
      name: 'imageUrl',
      title: 'Image',
      type: 'image',
    }),
    defineField({
      name: 'role',
      title: 'Role',
      type: 'string',
      description: 'Example: Writer, Poet, Novelist, etc.',
    }),
    defineField({
      name: 'ratingsSortable',
      title: 'Ratings Sortable',
      type: 'number',
      description: 'Average rating or sortable rating value',
      validation: (rule) => rule.min(0).max(5),
    }),
  ],
})

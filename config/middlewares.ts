export default [
  'strapi::logger',
  'strapi::errors',
  'strapi::security',
  // 'strapi::cors',
  {
    name: 'strapi::cors',
    config: {
      origin: '*', // Permite cualquier origen
      methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS', 'HEAD'],
      headers: ['Content-Type', 'Authorization', 'Origin', 'Accept'],
      keepHeaderOnError: true,
    },
  },
  'strapi::poweredBy',
  'strapi::query',
  'strapi::body',
  'strapi::session',
  'strapi::favicon',
  'strapi::public',
];

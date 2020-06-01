const plugins ={
  tailwindcss: {},
  autoprefixer: {}
};

if(process.env.NODE_ENV === 'production') {
  plugins.cssnano = {};
}

module.exports = {
  plugins: plugins
};

Deface::Override.new(
  :virtual_path => "layouts/decidim/footer/_mini",
  :name => "add_banner_to_footer",
  :insert_before => ".mini-footer",
  :text => "<div style='width: 100%; padding: 10px; display: flex; justify-content: center; font-weight: bold'><p>Plateforme développée par <a href='https://creativehandicap.org/' target='_blank' aria-label='Lien vers le site de Créative Handicap'>Créative Handicap<a> </p></div>"
)
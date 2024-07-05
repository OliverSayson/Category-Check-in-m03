
    SELECT 
    Distinct(a.id) AS ApplicationID,
    a.name AS Application_Name,
    p.id,
    m.download_url as URL,
    mw.site_url as Domain, 
    CASE 
            WHEN m.download_url LIKE '%play.google.%' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(m.download_url, 'id=', -1), '&', 1) 
            WHEN m.download_url LIKE '%itunes.apple%' OR m.download_url LIKE '%apps.apple.com%' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(m.download_url, '/id', -1), '?', 1) 
            ELSE '-' 
        END AS Bundle
    
    FROM pas_masterdata.pas_application a
    LEFT JOIN pas_masterdata.pas_mobile_website mw 
    ON mw.application_id = a.id
    LEFT JOIN pas_masterdata.pas_publisher p 
    ON a.publisher_id = p.id
    LEFT JOIN pas_masterdata.pas_mobile_app m 
    ON a.id = m.application_id
    WHERE 
       CASE 
            WHEN m.download_url LIKE '%play.google.%' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(m.download_url, 'id=', -1), '&', 1) 
            WHEN m.download_url LIKE '%itunes.apple%' OR m.download_url LIKE '%apps.apple.com%' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(m.download_url, '/id', -1), '?', 1) 
            ELSE '-' 
        END IN ()
        AND p.blocked != 1
        AND a.blocked != 1


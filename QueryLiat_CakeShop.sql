# function validasi_jumlah_kue
CREATE OR REPLACE FUNCTION validasi_jumlah_kue()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.item_amount < 0 THEN
        RAISE EXCEPTION 'Jumlah kue tidak boleh negatif';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

# trigger function validasi_jumlah_kue
CREATE TRIGGER trigger_validasi_jumlah_kue
BEFORE INSERT OR UPDATE ON transaction_item
FOR EACH ROW
EXECUTE FUNCTION validasi_jumlah_kue();

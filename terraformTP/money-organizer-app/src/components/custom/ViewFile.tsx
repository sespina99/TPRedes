import { FileResponse } from "@/types/Interfaces";
import PdfViewerComponent from "@/components/custom/PdfViewerComponent";

interface Props {
  fileResponse: FileResponse;
}

const ViewFile = ({ fileResponse }: Props) => {
  return (
    <>
      <div>
        {fileResponse.file && (
          <PdfViewerComponent fileBase64String={fileResponse.file} />
        )}
        {!fileResponse.file && <p>{fileResponse.error_message}</p>}
      </div>
    </>
  );
};

export default ViewFile;

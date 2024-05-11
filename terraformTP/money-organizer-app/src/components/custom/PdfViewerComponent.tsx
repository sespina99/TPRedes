import { Viewer } from "@react-pdf-viewer/core";
import { useState, useEffect } from "react";

interface Props {
  fileBase64String: string;
}

const PdfViewerComponent = ({ fileBase64String }: Props) => {
  const [fileUrl, setFileUrl] = useState("");

  const base64ToDataURL = (base64String: any) => {
    return `data:application/pdf;base64,${base64String}`;
  };

  useEffect(() => {
    setFileUrl(base64ToDataURL(fileBase64String));
  }, []);

  return (
    <>
      <div>
        <Viewer fileUrl={fileUrl} />
      </div>
    </>
  );
};

export default PdfViewerComponent;

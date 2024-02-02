export interface props{
    imageID: string
}

export const ImageComponent: React.FC<props> = (props) => {
    return(
            <img src={process.env.PUBLIC_URL + '/images/' + props.imageID + '.png'} />
      
    );
}